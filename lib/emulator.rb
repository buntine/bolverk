class Bolverk::Emulator
  attr_reader :main_memory, :registers, :program_counter, :instruction_register

  # Class-mapping for instruction codes.
  @operation_codes = {
#    "0001" => Bolverk::Operations::LoadFromMemory,
#    "0010" => Bolverk::Operations::LoadFromValue,
#    "0011" => Bolverk::Operations::Store,
#    "0100" => Bolverk::Operations::Move,
#    "0101" => Bolverk::Operations::AddBinary,
#    "0110" => Bolverk::Operations::AddFloatingPoint,
#    "0111" => Bolverk::Operations::Or,
#    "1000" => Bolverk::Operations::And,
#    "1001" => Bolverk::Operations::Xor,
#    "1010" => Bolverk::Operations::Rotate,
#    "1011" => Bolverk::Operations::Jump,
#    "1100" => Bolverk::Operations::Beep,
#    "1101" => Bolverk::Operations::Print,
#    "1110" => Bolverk::Operations::Halt,
  }

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

  # Loads a single value into memory at memory location specified
  # by memory_cell. Values and memory addresses should be passed
  # in as hexadecimal.
  def load_value_into_memory(memory_cell, data="00")
    cell = memory_cell.hex
    @main_memory[cell] = convert_from_hex_to_binary(data, 8)
  end

  # Loads an array of hexadecimal values into main memory, starting
  # at memory address specified by memory_cell.
  def load_values_into_memory(memory_cell, data=[])
    data.each_with_index do |code, index|
      cell = memory_cell.hex + index
      cell = cell.to_s(base=16)
      load_value_into_memory(cell, code)
    end
  end

  # Returns the value of memory cell identified by memory_cell.
  def fetch_value_from_memory(memory_cell)
    cell = memory_cell.hex
    @main_memory[cell]
  end

  private

    # Returns an n-bit string. Smaller values are padded
    # with zeros.
    def convert_from_hex_to_binary(data="", size=16)
      data.hex.to_s(base=2).rjust(size, "0")
    end

    # Each instruction requires two cells of main memory, so
    # we snap the argument into byte-size chunks.
    def insert_instruction_into_memory(instruction, cell=0)
      @main_memory[cell] = instruction[0..7]
      @main_memory[cell + 1] = instruction[8..15]
    end

end
