class Bolverk::Stack
  attr_reader :stack

  def initialize(scope=1)
    @stack = [ "0" * 8 ] * scope
  end

 protected

  def set(index, data)
    index.binary_to_hex! if index.is_bitstring?
    @stack[index.hex] = data
  end

  def get(index)
    index.binary_to_hex! if index.is_bitstring?
    @stack[index.hex]
  end

  def get_multiple(index, offset)
    index.binary_to_hex! if index.is_bitstring?
    @stack[index.hex, offset]
  end

end
