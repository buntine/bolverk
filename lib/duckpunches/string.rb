class String

  def is_bitstring?
    # A little stupid, but I want these to return a boolean over 0/nil.
    !(self =~ /^[01]{4,}$/).nil?
  end

  def is_hexadecimal?
    !(self =~ /^[0-9A-Fa-f]+$/).nil?
  end

  # Sourced from: http://pleac.sourceforge.net/pleac_ruby/numbers.html
  def binary_to_hex
    raise RuntimeError, "Data is not valid Binary: #{self}" unless self.is_bitstring?

    decimal = [("0"*32+self.to_s)[-32..-1]].pack("B32").unpack("N")[0]
    decimal.to_s(base=16).upcase
  end

  # Returns an n-bit string. Smaller values are padded
  # with zeros.
  def hex_to_binary(size=16)
    raise RuntimeError, "Data is not valid Hexadecimal: #{self}" unless self.is_hexadecimal?

    self.hex.to_s(base=2).rjust(size, "0")
  end

  def binary_to_hex!
    self.replace(self.binary_to_hex)
  end

  def hex_to_binary!(size=16)
    self.replace(self.hex_to_binary(size))
  end

end
