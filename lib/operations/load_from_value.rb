class Bolverk::Operations::LoadFromValue < Bolverk::Operations::Base

  map_to "0010"

  parameter_layout [ [:register, 4], [:value, 8] ]

  # Stores the value at operand 2 and 3 in the register at "register".
  #
  # Example:
  #   2AFF => 0010101011111111 => Store the value 11111111 in the register A
  def execute
    @emulator.register_write(@register, @value)
  end

end
