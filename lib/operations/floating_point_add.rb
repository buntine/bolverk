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

  # Reads in a binary string that is stored in floating-point
  # notation and transforms it into a float.
  def decode_floating_point(bitstring)
    sign_bit = bitstring[0..0]
    exponent = bitstring[1..3]
    mantissa = bitstring[4..7]

    # Read in the exponent using excess-four.
    radix_point = exponent.binary_to_decimal(4)

    # Shift the radix to the left.
    if radix_point <= 0
      whole = 0
      mantissa = mantissa.rjust(4 + radix_point.abs, "0")
    # Shift the radix to the right.
    else
      whole = mantissa[0, radix_point]
      whole = whole.binary_to_decimal
      mantissa = mantissa[radix_point..3]
    end

    fraction = fractional_binary_to_decimal(mantissa)
    result = whole + fraction

    (sign_bit == "0") ? result : -result
  end

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

  # Generates a decimal representation of a fractional
  # portion of a binary number.
  def fractional_binary_to_decimal(bitstring)
    fraction = 0.0
    precision = 2

    # Traverse the bitstring, each time adding
    # the fractional portion to our total and raising
    # the precision to the next power.
    bitstring.each_byte do |bit|
      fraction += bit.chr.to_f / precision
      precision *= 2
    end

    fraction
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
