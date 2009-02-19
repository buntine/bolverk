class Bolverk::Emulator
  include Bolverk::Operations

  attr_reader :main_memory, :registers, :instruction_register
  attr_accessor :program_counter

  def initialize
    @main_memory = [ "0" * 8 ] * 256 
    @registers = [ "0" * 8 ] * 16
  end

  # Initializes the program counter to the given memory cell.
  def start_program(memory_cell)
    @program_counter = memory_cell
    @instruction_register = Bolverk::InstructionRegister.new
  end

  # Executes a single program instruction.
  def perform_machine_cycle
    raise Bolverk::NullProgramCounterError if @program_counter.nil?

    update_instruction_register
    increment_program_counter
    circuitry = handler_for_op_code(@instruction_register.op_code)

    # Execute the correct operation.
    unless circuitry.nil?
      handler = circuitry.new(self)
      handler.execute
    else
      raise Bolverk::UnknownOpCodeError, "Unknown operation code: #{@instruction_register.op_code}"
    end
  end

  # Programs should be written in binary or hexadecimal.
  # A program must be passed in as an array of individual
  # instructions.
  def load_program_into_memory(memory_cell, program=[])
    program.each_with_index do |instruction, index|
      cell = memory_cell.hex + (index * 2)
      insert_instruction_into_memory(instruction, cell)
    end
  end

  def load_values_into_memory(memory_cell, data=[])
    data.each_with_index do |code, index|
      cell = memory_cell.hex + index
      cell = cell.to_s(base=16)
      memory_write(cell, code)
    end
  end
  
  def memory_read(cell)
    @main_memory.read(cell)
  end

  def memory_write(cell, value="00")
    value.hex_to_binary!(8) unless value.is_bitstring?
    @main_memory.write(cell, value)
  end

  def register_read(cell)
    @registers.read(cell)
  end

  def register_write(cell, value="00")
    value.hex_to_binary!(8) unless value.is_bitstring?
    @registers.write(cell, value)
  end

 private

  # Each instruction requires two cells of main memory, so
  # we snap the argument into byte-size chunks.
  def insert_instruction_into_memory(instruction, cell=0)
    instruction.hex_to_binary! unless instruction.is_bitstring?
    @main_memory[cell] = instruction[0..7]
    @main_memory[cell + 1] = instruction[8..15]
  end

  # Fetches the next program instruction and store it in the instruction register.
  def update_instruction_register
    cell = @program_counter.hex
    @instruction_register.update_with @main_memory[cell, 2].join
  end

  # Increments the program counter by two places (each instruction requires two memory cells).
  def increment_program_counter
    counter = @program_counter.hex + 2
    @program_counter = counter.to_s(base=16).upcase
  end

end
