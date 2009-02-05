class Bolverk::Operations::LoadFromMemory < Bolverk::Operations::Base

  map_to "0001"

  # Operation layout:
  #   xxxx | xxxx | xxxxxxxx
  #   op_code | register | memory_cell
  #
  # Stores the value stored at "memory_cell" in the register at "register".
  #
  # Example:
  #   1A42 => 0001101001000010 => Store the value at memory cell 42 in the register A
  def execute
    instruction = @emulator.instruction_register

    register = instruction.operand(1)
    memory_cell = instruction.operand(2) + instruction.operand(3)

    @emulator.store_memory_address_in_register(register, memory_cell)
  end

end
