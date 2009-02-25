class Bolverk::Stack
  attr_reader :stack

  # Move shit out of emulator and into MainMemory, etc.

  def initialize(scope=1)
    @stack = [ "0" * 8 ] * scope
  end

 protected

  # Helper methods so index can be specified as binary or hexadecimal.

  def write(index, data)
    index.binary_to_hex! if index.is_bitstring?
    @stack[index.hex] = data
  end

  def read(index)
    index.binary_to_hex! if index.is_bitstring?
    @stack[index.hex]
  end

end
