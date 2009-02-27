class Bolverk::Registers < Bolverk::Stack

  def initialize
    super(16)
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

  def is_valid_register_address?(cell)
    value = cell.is_bitstring? ? cell.binary_to_hex : cell
    value.upcase =~ /^[0-9A-F]{1}$/
  end

  # A helper method to encapsulate some logic in a safeguard
  # to ensure the memory cell exists.
  def validate(cell, allow_ff=true, &block)
    if is_valid_register_address?(cell)
      yield 
    else
      raise Bolverk::InvalidMemoryAddress, "No such register address: #{cell}"
    end
  end

end
