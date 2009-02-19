class Bolverk::Operations::Jump < Bolverk::Operations::Base

  map_to "1011"

  parameter_layout [ [:register, 4], [:memory_cell, 8] ]

  # Jumps program execution to "memory_cell" if register number R is equal to register 0.
  # Otherwise, normal program execution continues. This is, in effect, a primitive conditional
  # gate.
  #
  # Example:
  #   B5F2 => 1011010111110010 => Jump to memory cell F2 is register 5 is equal register 0.
  def execute
    register_0 = @emulator.register_read("0")
    register_n = @emulator.register_read(@register)

    # All we have to do is conditionally update the program counter and the
    # emulator will blindly follow orders.
    if register_0.eql?(register_n)
      @emulator.program_counter = @memory_cell.binary_to_hex
    end
  end

end
