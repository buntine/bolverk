# TODO: This class contains some pretty messy code. It needs a cleanup.

class Bolverk::Operations::FloatingPointAdd < Bolverk::Operations::Base

  map_to "0110"

  parameter_layout [ [:register_a, 4], [:register_b, 4], [:destination, 4] ]

  # Adds the values in register A and register B as if they were values
  # stored in Floating Point notation and store the results in register C.
  #
  # Example:
  #   625A => 0110001001011010=> Add registers 2 and 5 together and store the result in register A.
  def execute
    operand_a = decode_floating_point(@emulator.register_read(@register_a))
    operand_b = decode_floating_point(@emulator.register_read(@register_b))

    result = encode_floating_point(operand_a + operand_b)

    @emulator.register_write(@destination, result)
  end

 private

  # Read in a float and transforms it into a bitstring suitable
  # for storage in floating-point notation.
  def encode_floating_point(float)
    whole = float.to_i
    fraction = fractional_decimal_to_binary(float % 1)

    if whole == 0
      # Store an exponent that lets the decoded know which direction the
      # radix point needs to move in relative to the mantissa.
      if fraction.length > 4
        exponent = (4 - (fraction.length - 4)).to_s(base=2).rjust(3, "0")
      else
        # 0 in excess-four. The radix point does not move.
        exponent = "100"
      end
    else
      # Store the position of the radix in excess-four.
      exponent = (whole.to_s(base=2).length + 4).to_s(base=2)
    end

    mantissa = (whole > 0) ? whole.to_s(base=2) : ""
    mantissa << (fraction[-4, 4] || fraction)
    sign_bit = (float < 0) ? "1" : "0"

    (sign_bit + exponent + mantissa).ljust(8, "0")
  end

  # Generates a binary representation of a fractional
  # portion of a decimal number.
  def fractional_decimal_to_binary(float)
    bitstring = ""
    fraction = float
    
    # Double the fractional portion continuously until we get a whole
    # or reach our desired limit. Each time, the whole will
    # be either 1 or 0 (which is used to build the bitstring).
    while !fraction.zero? and bitstring.length < 8 do
      fraction *= 2
      bitstring << fraction.floor.to_s
      fraction %= 1
    end

    bitstring
  end

end
