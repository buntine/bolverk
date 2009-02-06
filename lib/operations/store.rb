class Bolverk::Operations::Store < Bolverk::Operations::Base

  map_to "0011"

  # Operation layout:
  #   xxxx | xxxx | xxxxxxxx
  #   op_code | register | memory_cell
  #
  # Stores the value stored in register "register" in the memory_cell at "memory_cell".
  #
  # Example:
  #   3A42 => 0011101001000010 => Store the value at register A in the memory cell identified by 42.
  def execute
    instruction = @emulator.instruction_register

    register = instruction.operand(1)
    memory_cell = instruction.operand(2) + instruction.operand(3)

    @emulator.store_register_in_memory_address(register, memory_cell)
  end

end
