class Array

  def write(index, data)
    index.binary_to_hex! if index.is_bitstring?
    self[index.hex] = data
  end

  def read(index)
    index.binary_to_hex! if index.is_bitstring?
    self[index.hex]
  end

end
