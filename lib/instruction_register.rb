# A helper class to provide a cleaner interface to the emulator and it's operation classes.
# This is more-or-less a wrapper around a 16-bit binary string.
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
    operand
  end

  # Return the appropriate operand.
  def operand(num=0)
    raise Bolverk::InvalidOperandError unless (0..3).include?(num)

    @instruction[num * 4, 4]
  end
end
