class Bolverk::MainMemory < Bolverk::Stack

  def initialize
    super(256)
  end

  def load_instructions(cell, instructions)
    validate(cell, false) do
      instructions.each_with_index do |instruction, index|
        memory_cell = (cell.hex + (index * 2)).to_s(base=16).rjust(2, "0")
        insert_instruction(memory_cell, instruction)
      end
    end
  end
 
  def read_instruction(cell)
    validate(cell, false) do
      get_multiple(cell, 2).join
    end
  end

  def read(cell)
    validate(cell) do
      get(cell)
    end
  end

  def write(cell, value="00")
    validate(cell) do
      value.hex_to_binary!(8) unless value.is_bitstring?
      set(cell, value)
    end
  end

 private

  # A helper method to encapsulate some logic in a safeguard
  # to ensure the memory cell exists.
  def validate(cell, allow_ff=true, &block)
    last_cell = allow_ff ? false : cell.upcase.eql?("FF")
    if is_valid_memory_address?(cell) and !last_cell
      yield 
    else
      raise Bolverk::InvalidMemoryAddress, "No such memory address: #{cell}"
    end
  end

  def is_valid_memory_address?(cell)
    value = cell.is_bitstring? ? cell.binary_to_hex : cell
    value.upcase =~ /^[0-9A-F]{2}$/
  end

  # Each instruction requires two cells of main memory, so
  # we snap the argument into byte-size chunks.
  def insert_instruction(cell, instruction)
    instruction.hex_to_binary! unless instruction.is_bitstring?
    write(cell, instruction[0..7])
    write((cell.hex + 1).to_s(base=16).rjust(2, "0"), instruction[8..15])
  end

end

