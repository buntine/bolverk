class Bolverk::Operations::LoadFromValue < Bolverk::Operations::Base

  map_to "0010"

  # Operation layout:
  #   xxxx | xxxx | xxxxxxxx
  #   op_code | register | value
  #
  # Stores the value at operand 2 and 3 in the register at "register".
  #
  # Example:
  #   2AFF => 0010101011111111 => Store the value 11111111 in the register A
  def execute
    instruction = @emulator.instruction_register

    register = instruction.operand(1)
    value = instruction.operand(2) + instruction.operand(3)

    @emulator.register_write(register, value)
  end

end
