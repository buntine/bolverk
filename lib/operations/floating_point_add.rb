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

    operand_a = floating_point_to_float(@emulator.register_read(register_a))
    operand_b = floating_point_to_float(@emulator.register_read(register_b))

    raise RuntimeError, "Expected 1.125, but got: #{operand_a}" unless operand_a == 1.125
    raise RuntimeError, "Expected 0.5, but got: #{operand_b}" unless operand_b == 0.5

    # Get bitstring from memory
    # Extract mantissa
    # Extract exponent
    # n = Evaluate exponent in excess-four.
    # n < 0
      # pad n.abs zeroes onto the left of the mantissa.
    # n > 0
      # move the radix point n positions to the right in the mantissa.
    # evaluate the left of the radix (if present) as binary.
    # evaluate the right side of the radix using magic fractional counter: (1.to_f / x) + (0.to_f / x*2) + (1.to_f / x*4) + etc...

  end

 private

  def floating_point_to_float(bitstring)
    mantissa = bitstring[4..7]
    exponent = bitstring[1..3]
    sign_bit = bitstring[0,1]

    radix_point = exponent.binary_to_decimal(4)

    if radix_point <= 0
      whole = 0
      mantissa = mantissa.rjust(4 + radix_point.abs, "0")
    else
      whole = mantissa[0, radix_point]
      whole = whole.binary_to_decimal
      mantissa = mantissa[radix_point..3]
    end

    fraction = fractional_binary_to_decimal(mantissa)

    whole + fraction
  end

  def fractional_binary_to_decimal(bitstring)
    fraction = 0.0
    precision = 2

    bitstring.each_byte do |bit|
      fraction += bit.chr.to_f / precision
      precision *= 2
    end

    fraction
  end

end
