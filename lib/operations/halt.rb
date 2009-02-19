class Bolverk::Operations::Halt < Bolverk::Operations::Base

  map_to "1100"

  parameter_layout [ [:ignored, 16] ]

  # Halts program execution. No parameters are accepted.
  #
  # Example:
  #   C000 => 1100000000000000 => End program.
  def execute
    @emulator.program_counter = nil
    @emulator.instruction_register.update_with("0" * 16)
  end

end
