class Bolverk::Operations::Print < Bolverk::Operations::Base

  map_to "1101"

  parameter_layout [ [:ignored, 4], [:memory_cell, 8] ]

  # Prints the value stored at memory_cell to the standard output. The value is assumed
  # to be a valid ASCII character code.
  #
  # Example:
  #   C05A => 1101000001011010 => Print the value stored in memory address 5A to stdout.
  def execute
    value = @emulator.memory_read(@memory_cell)

    puts value.binary_to_decimal.chr
  end

end
