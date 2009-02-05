class Bolverk::InstructionRegister
  attr_reader :instruction

  def initialize(bitstring="0000000000000000")
    @instruction = bitstring
  end

  # Store a new instruction.
  def update_with(bitstring)
    @instruction = bitstring
  end

  # Return the operation code (first 4 bits).
  def op_code
    @instruction[0..3]
  end

  # Return the appropriate operand.
  def operand(num=1)
    raise Bolverk::InvalidOperandError unless (1..3).include?(num)

    @instruction[num * 4, 4]
  end
end
