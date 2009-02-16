class Bolverk::Operations::Xor < Bolverk::Operations::Base

  map_to "1001"

  parameter_layout [ [:register_a, 4], [:register_b, 4], [:destination, 4] ]

  # Performs an Exclusive OR operation on register_a and register_b and stores the result in "destination".
  #
  # Example:
  #   925A => 1001001001011010=> XOR the contents of registers 2 and 5 and store the result in register A.
  def execute
    operand_a = @emulator.register_read(@register_a)
    operand_b = @emulator.register_read(@register_b)

    result = perform_xor(operand_a, operand_b)

    @emulator.register_write(@destination, result)
  end

 private

  # Performs an XOR operation on two binary codes.
  def perform_xor(mask, source)
    result = ""

    (0..mask.length-1).each do |byte|
      if (mask[byte] == ?0 and source[byte] == ?0) or (mask[byte] == ?1 and source[byte] == ?1)
        result << "0"
      else
        result << "1"
      end
    end

    result
  end

end
