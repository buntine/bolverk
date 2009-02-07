class Bolverk::Operations::BinaryAdd < Bolverk::Operations::Base

  map_to "0101"

  # Operation layout:
  #   xxxx | xxxx | xxxx | xxxx
  #   op_code | register_a | register_b | register_c
  #
  # Adds the values in register A and register B as if they were binary
  # numbers and stores the result in register C.
  #
  # Example:
  #   525A => 0101001001011010=> Add registers 2 and 5 together and store the result in register A.
  def execute
    instruction = @emulator.instruction_register

    register_a = instruction.operand(1)
    register_b = instruction.operand(2)
    destination = instruction.operand(3)

    operand_a = @emulator.register_read(register_a).binary_to_hex
    operand_b = @emulator.register_read(register_b).binary_to_hex

    result = (operand_a.hex + operand_b.hex).to_s(base=16)

    @emulator.register_write(destination, result)
  end

end
