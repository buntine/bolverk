class Bolverk::Operations::And < Bolverk::Operations::Base

  map_to "1000"

  parameter_layout [ [:register_a, 4], [:register_b, 4], [:destination, 4] ]

  # Performs an AND operation on register_a and register_b and stores the result in "destination".
  #
  # Example:
  #   825A => 1000001001011010=> AND the contents of registers 2 and 5 and store the result in register A.
  def execute
    operand_a = @emulator.register_read(@register_a)
    operand_b = @emulator.register_read(@register_b)

    result = perform_and(operand_a, operand_b)

    @emulator.register_write(@destination, result)
  end

 private

  # Performs an AND operation on two binary codes.
  def perform_and(mask, source)
    result = ""

    (0..mask.length-1).each do |byte|
      result.concat((mask[byte] == ?1 and source[byte] == ?1) ? "1" : "0")
    end

    result
  end

end
