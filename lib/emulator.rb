class Bolverk::Emulator
  attr_reader :main_memory, :registers

  def initialize
    @main_memory = [ "00000000" ] * 256 
    @registers = [ "00000000" ] * 16
  end

  # Programs should be written in binary or hexadecimal.
  # A program must be passed in as an array of individual
  # instructions.
  def load_program_into_memory(program=[])
    program.each_with_index do |instruction, index|
      binary = convert_from_hex_to_binary(instruction)
      cell = index * 2

      insert_instruction_into_memory(binary, cell)
    end
  end

  private

    # Returns an 16-bit string. Smaller values are padded
    # with zeros.
    def convert_from_hex_to_binary(data="")
      data.hex.to_s(base=2).rjust(16, "0")
    end

    # Each instruction requires two cells of main memory, so
    # we snap the argument into byte-size chunks.
    def insert_instruction_into_memory(instruction, cell=0)
      @main_memory[cell] = instruction[0..7]
      @main_memory[cell + 1] = instruction[8..15]
    end

end
