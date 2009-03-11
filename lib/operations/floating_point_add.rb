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

end
