class Bolverk::Operations::LoadFromMemory < Bolverk::Operations::Base

  map_to "0001"

  parameter_layout [ [:register, 4], [:cell, 8] ]

  # Stores the value stored at "memory_cell" in the register at "register".
  #
  # Example:
  #   1A42 => 0001101001000010 => Store the value at memory cell 42 in the register A
  def execute
    @emulator.register_write(@register, @emulator.memory_read(@cell))
  end

end
