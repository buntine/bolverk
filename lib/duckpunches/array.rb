class Array

  # Helper methods so index can be specified as binary or hexadecimal.

  def write(index, data)
    index.binary_to_hex! if index.is_bitstring?
    self[index.hex] = data
  end

  def read(index)
    index.binary_to_hex! if index.is_bitstring?
    self[index.hex]
  end

end
