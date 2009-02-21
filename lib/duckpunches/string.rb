class String

  def is_bitstring?(min=4)
    # A little stupid, but I want these to return a boolean over 0/nil.
    !(self =~ /^[01]{#{min},}$/).nil?
  end

  def is_hexadecimal?
    !(self =~ /^[0-9A-Fa-f]+$/).nil?
  end

  # Inverts a bit string: 0011101 becomes 1100010.
  def complement!
    raise RuntimeError, "Data is not valid Binary: #{self}" unless self.is_bitstring?
    complement = ""

    self.each_byte do |char|
      complement << ((char.chr == "0") ? "1" : "0")
    end

    self.replace(complement)
  end

  # Increments a bit string: 00101 becomes 00110.
  def increment!(amount=1)
    raise RuntimeError, "Data is not valid Binary: #{self}" unless self.is_bitstring?

    size = self.length
    decimal = self.binary_to_decimal + amount

    if decimal > 255
      raise Bolverk::OverflowError, "Cannot store decimal value: #{decimal}"
    else
      self.replace(decimal.to_s(base=2).rjust(size, "0"))
    end
  end

  # Sourced from: http://pleac.sourceforge.net/pleac_ruby/numbers.html
  def binary_to_decimal(excess=0)
    raise RuntimeError, "Data is not valid Binary: #{self}" unless self.is_bitstring?(1)

    [("0"*32+self.to_s)[-32..-1]].pack("B32").unpack("N")[0] - excess
  end

  # Converts from base-2 to base-16.
  # "00111010" => "3A"
  def binary_to_hex
    raise RuntimeError, "Data is not valid Binary: #{self}" unless self.is_bitstring?

    decimal = self.binary_to_decimal
    hex = decimal.to_s(base=16).upcase

    # Pad to preserve leading zeroes in bitstring.
    if self.length % 4 == 0
      hex = hex.rjust((self.length / 4), "0")
    end

    hex
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
