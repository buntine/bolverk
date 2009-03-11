class Bolverk::Operations::BinaryAdd < Bolverk::Operations::Base

  map_to "0101"

  parameter_layout [ [:register_a, 4], [:register_b, 4], [:destination, 4] ]

  # Adds the values in register A and register B as if they were binary
  # numbers and stores the result in register C.
  #
  # Example:
  #   525A => 0101001001011010=> Add registers 2 and 5 together and store the result in register A.
  def execute
    operand_a = decode_twos_complement(@emulator.register_read(@register_a))
    operand_b = decode_twos_complement(@emulator.register_read(@register_b))

    result = operand_a + operand_b

    # Ensure the value can be encoded with 8-bits.
    if (-125..124).include?(result)
      @emulator.register_write(@destination, encode_twos_complement(result))
    else
      raise Bolverk::OverflowError, "Cannot store integer: #{result}"
    end
  end

end
