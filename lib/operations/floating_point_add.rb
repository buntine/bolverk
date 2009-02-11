class Bolverk::Operations::FloatingPointAdd < Bolverk::Operations::Base

  map_to "0110"

  # Operation layout:
  #   xxxx | xxxx | xxxx | xxxx
  #   op_code | register_a | register_b | register_c
  #
  # Adds the values in register A and register B as if they were values
  # stored in Floating Point notation and store the results in register C.
  #
  # Example:
  #   625A => 0110001001011010=> Add registers 2 and 5 together and store the result in register A.
  def execute
    instruction = @emulator.instruction_register

    register_a = instruction.operand(1)
    register_b = instruction.operand(2)
    destination = instruction.operand(3)

    operand_a = decode_floating_point(@emulator.register_read(register_a))
    operand_b = decode_floating_point(@emulator.register_read(register_b))

    result = encode_floating_point(operand_a + operand_b)

    @emulator.register_write(destination, result)
  end

 private

  # Reads in a binary string that is stored in floating-point
  # notation and transforms it into a float.
  def decode_floating_point(bitstring)
    mantissa = bitstring[4..7]
    exponent = bitstring[1..3]
    sign_bit = bitstring[0,1]

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
    fraction = fractional_decimal_to_binary(float - whole)

    if whole == 0
      if fraction.length > 4
        exponent = (4 - (fraction.length - 4)).to_s(base=2).rjust(3, "0")
      else
        exponent = "100"
      end
    else
      exponent = (whole.to_s(base=2).length + 4).to_s(base=2)
    end

    fraction = (fraction.length > 4) ? fraction[-4, 4] : fraction
    whole = (whole > 0) ? whole.to_s(base=2) : ""
    mantissa = whole + fraction
    sign_bit = (float < 0) ? "1" : "0"

    # Grab the whole: float.to_i
    # fraction = float.fraction.to_binary
    # if whole is 0
      # if fraction.length > 4
        # exponent = (4 - (fraction.length - 4)).to_binary.rjust(3, "0")
      # else
        # exponent = 100
    # else
      # exponent = whole.to_binary.length + 4.to_binary
    # mantissa = whole.to_binary + fraction.last_4_bits_or_less
    # sign_bit = (float < 0) ? "1" : "0"
    # sign_bit + exponent + mantissa (ljust this to 8, pad with 0's)

    (sign_bit + exponent + mantissa).ljust(8, "0")
  end

  # Generates a decimal representation of a fractional
  # portion of a binary number.
  def fractional_binary_to_decimal(bitstring)
    fraction = 0.0
    precision = 2

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
    
    while !fraction.zero? and bitstring.length < 8 do
      fraction *= 2
      whole = fraction.to_i
      bitstring << whole.to_s
      fraction -= whole
    end

    bitstring
  end

end
