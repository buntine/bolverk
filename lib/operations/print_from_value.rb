class Bolverk::Operations::PrintFromValue < Bolverk::Operations::Base

  map_to "1110"

  parameter_layout [ [:method, 4], [:value, 8] ]

  # Prints the value specified by "value" to the standard output.
  # The first operand determines the type of data that is expected:
  # 0 => ASCII character code
  # 1 => Binary integer (incoded in Two's Complement)
  # 2 => Floating-point integer
  #
  # Any other value (3-F) in the first operand will default to ASCII character code.
  #
  # Example:
  #   E05A => 1110000001011010 => Print the value 5A to stdout (as ASCII character).
  #   E15B => 1110000101011011 => Print the value 5B to stdout (as decimal integer).
  #   E25C => 1110001001011101 => Print the value 5C to stdout (as decimal float).
  def execute
    case @method
      when "0001"
        print decode_twos_complement(@value)
      when "0010"
        print decode_floating_point(@value)
      else
        print @value.binary_to_decimal.chr
    end
  end

end
