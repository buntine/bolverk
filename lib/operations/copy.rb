class Bolverk::Operations::Copy < Bolverk::Operations::Base

  map_to "0100"

  parameter_layout [ [:ignore, 4], [:source, 4], [:destination, 4] ]

  # Copies the value stored in register "source" into register "destination".
  #
  # Example:
  #   4049 => 0100000001001001 => Copy the value at register 4 into register 9.
  def execute
    instruction = @emulator.instruction_register

    source = instruction.operand(2)
    @emulator.register_write(@destination, @emulator.register_read(@source))
  end

end
