class Bolverk::Operations::PrintFromMemory < Bolverk::Operations::Base

  map_to "1101"

  parameter_layout [ [:method, 4], [:memory_cell, 8] ]

  # Prints the value stored at memory_cell to the standard output.
  # The first operand determines the type of data that is expected:
  # 0 => ASCII character code
  # 1 => Binary integer (incoded in Two's Complement)
  # 2 => Floating-point integer
  #
  # Any other value (3-F) in the first operand will default to ASCII character code.
  #
  # Example:
  #   D05A => 1101000001011010 => Print the value stored in memory address 5A to stdout (as ASCII character).
  #   D15A => 1101000101011010 => Print the value stored in memory address 5A to stdout (as decimal integer).
  #   D25A => 1101001001011010 => Print the value stored in memory address 5A to stdout (as decimal float).
  def execute
    value = @emulator.memory_read(@memory_cell)

    case @method
      when "0001"
        print decode_twos_complement(value)
      when "0010"
        print decode_floating_point(value)
      else
        print value.binary_to_decimal.chr
    end
  end

end
