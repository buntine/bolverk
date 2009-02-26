class Bolverk::Emulator
  include Bolverk::Operations

  attr_reader :registers, :instruction_register
  attr_accessor :program_counter

  def initialize
    @main_memory = Bolverk::MainMemory.new
    @registers = [ "0" * 8 ] * 16
  end

  # Keep the object hidden and just return the raw stack.
  def main_memory
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

  def load_program_into_memory(cell, program=[])
    @main_memory.load_instructions(cell, program)
  end

  def memory_read(cell)
    @main_memory.read(cell)
  end

  def memory_write(cell, value="00")
    @main_memory.write(cell, value)
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

  def is_valid_register_address?(cell)
    value = cell.is_bitstring? ? cell.binary_to_hex : cell
    value.upcase =~ /^[0-9A-F]{1}$/
  end

  # Fetches the next program instruction and store it in the instruction register.
  def update_instruction_register
    @instruction_register.update_with @main_memory.read_instruction(@program_counter)
  end

  # Increments the program counter by two places (each instruction requires two memory cells).
  def increment_program_counter
    counter = @program_counter.hex + 2
    @program_counter = counter.to_s(base=16).upcase
  end

end
