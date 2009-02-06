class Bolverk::Emulator
  include Bolverk::Operations

  attr_reader :main_memory, :registers, :program_counter, :instruction_register

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
      insert_instruction_into_memory(instruction.hex_to_binary, cell)
    end
  end

  # Loads a single value into memory at memory location specified
  # by memory_cell. Values and memory addresses should be passed
  # in as hexadecimal.
  def load_value_into_memory(memory_cell, data="00")
    cell = memory_cell.hex
    @main_memory[cell] = data.hex_to_binary(8)
  end

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

  # Stores the value at a memory address into a register, identified by the first operand.
  def store_memory_address_in_register(register, memory_cell)
    register.binary_to_hex! if register.is_bitstring?
    memory_cell.binary_to_hex! if memory_cell.is_bitstring?

    @registers[register.hex] = @main_memory[memory_cell.hex]
  end

  # Stores a value into a register, identified by the first operand.
  def store_value_in_register(register, value)
    register.binary_to_hex! if register.is_bitstring?
    value.hex_to_binary!(8) unless value.is_bitstring?

    @registers[register.hex] = value
  end

  # Stores the value at a register into a memory_address.
  def store_register_in_memory_address(register, memory_cell)
    register.binary_to_hex! if register.is_bitstring?
    memory_cell.binary_to_hex! if memory_cell.is_bitstring?

    @main_memory[memory_cell.hex] = @registers[register.hex]
  end

 private

  # Each instruction requires two cells of main memory, so
  # we snap the argument into byte-size chunks.
  def insert_instruction_into_memory(instruction, cell=0)
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
