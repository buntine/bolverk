class Bolverk::Operations::Copy < Bolverk::Operations::Base

  map_to "0100"

  # Operation layout:
  #   xxxx | 0000 | xxxx | xxxx
  #   op_code | unused | source | destination
  #
  # Copies the value stored in register "source" into register "destination".
  #
  # Example:
  #   4049 => 0100000001001001 => Copy the value at register 4 into register 9.
  def execute
    instruction = @emulator.instruction_register

    source = instruction.operand(2)
    destination = instruction.operand(3)

    @emulator.register_write(destination, @emulator.register_read(source))
  end

end
