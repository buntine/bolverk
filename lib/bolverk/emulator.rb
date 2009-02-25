class Bolverk::Emulator
  include Bolverk::Operations

  attr_reader :registers, :instruction_register
  attr_accessor :program_counter

  def initialize
    @main_memory = Bolverk::MainMemory.new
    @registers = [ "0" * 8 ] * 16
  end

  def main_memory
    # Keep the object hidden and just return the raw stack.
    @main_memory.stack
  end

  # Initializes the program counter to the given memory cell.
  def start_program(cell)
    @program_counter = cell
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

  # A program must be passed in as an array of individual
  # instructions.
  def load_program_into_memory(cell, program=[])
    raise Bolverk::InvalidMemoryAddress unless is_valid_memory_address?(cell) and !cell.upcase.eql?("FF")

    program.each_with_index do |instruction, index|
      memory_cell = cell.hex + (index * 2)
      insert_instruction_into_memory(instruction, memory_cell)
    end
  end

  def memory_read(cell)
    if is_valid_memory_address?(cell)
      @main_memory.read(cell)
    else
      raise Bolverk::InvalidMemoryAddress, "No such memory address: #{cell}"
    end
  end

  def memory_write(cell, value="00")
    if is_valid_memory_address?(cell)
      value.hex_to_binary!(8) unless value.is_bitstring?
      @main_memory.write(cell, value)
    else
      raise Bolverk::InvalidMemoryAddress, "No such memory address: #{cell}"
    end
  end

  def register_read(cell)
    if is_valid_register_address?(cell)
      @registers.read(cell)
    else
      raise Bolverk::InvalidMemoryAddress, "No such register address: #{cell}"
    end
  end

  def register_write(cell, value="00")
    if is_valid_register_address?(cell)
      value.hex_to_binary!(8) unless value.is_bitstring?
      @registers.write(cell, value)
    else
      raise Bolverk::InvalidMemoryAddress, "No such register address: #{cell}"
    end
  end

 private

  def is_valid_memory_address?(cell)
    value = cell.is_bitstring? ? cell.binary_to_hex : cell
    value.upcase =~ /^[0-9A-F]{2}$/
  end

  def is_valid_register_address?(cell)
    value = cell.is_bitstring? ? cell.binary_to_hex : cell
    value.upcase =~ /^[0-9A-F]{1}$/
  end

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
