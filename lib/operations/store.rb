class Bolverk::Operations::Store < Bolverk::Operations::Base

  map_to "0011"

  parameter_layout [ [:register, 4], [:cell, 8] ]

  # Stores the value stored in register "register" in the memory_cell at "memory_cell".
  #
  # Example:
  #   3A42 => 0011101001000010 => Store the value at register A in the memory cell identified by 42.
  def execute
    @emulator.memory_write(@cell, @emulator.register_read(@register))
  end

end
