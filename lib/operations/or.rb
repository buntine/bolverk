class Bolverk::Operations::Or < Bolverk::Operations::Base

  map_to "0111"

  parameter_layout [ [:register_a, 4], [:register_b, 4], [:destination, 4] ]

  # Operation layout:
  #   xxxx | xxxx | xxxx | xxxx
  #   op_code | register_a | register_b | register_c
  #
  # Adds the values in register A and register B as if they were binary
  # numbers and stores the result in register C.
  #
  # Example:
  #   725A => 0111001001011010=> OR the contents of registers 2 and 5 and store the result in register A.
  def execute
 #   instruction = @emulator.instruction_register

 #   register_a = instruction.operand(1)
 #   register_b = instruction.operand(2)
 #   destination = instruction.operand(3)

    operand_a = @emulator.register_read(@register_a)
    operand_b = @emulator.register_read(@register_b)

    result = perform_or(operand_a, operand_b)

    @emulator.register_write(@destination, result)
  end

 private

  # Performs an OR operation on two binary codes.
  def perform_or(mask, source)
    result = ""

    (0..mask.length-1).each do |byte|
      result.concat((mask[byte] == ?0 and source[byte] == ?0) ? "0" : "1")
    end

    result
  end

end
