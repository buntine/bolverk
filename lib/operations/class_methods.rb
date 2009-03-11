
# Generic helper methods without side-effects. I have bunched them
# here so they can be easily accessed by any part of my app (or
# implementing software).

module Bolverk::Operations::ClassMethods

  def encode_twos_complement(number, size=8)
    bitstring = number.abs.to_s(base=2).rjust(size, "0")

    # Encode as negative value.
    if number < 0
      bitstring.complement!
      bitstring.increment!
    end

    bitstring
  end

  def decode_twos_complement(data)
    # Value is negative, decode it to get the real value.
    if data[0,1] == "1"
      decoded_value = data.clone
      decoded_value.complement!
      decoded_value.increment!
      -decoded_value.binary_to_decimal
    else
      data.binary_to_hex.hex
    end
  end

  def encode_floating_point(float)
    whole = float.to_i
    fraction = fractional_decimal_to_binary(float % 1)

    if whole == 0
      # Store an exponent that lets the decoded know which direction the
      # radix point needs to move in relative to the mantissa.
      if fraction.length > 4
        exponent = (4 - (fraction.length - 4)).to_s(base=2).rjust(3, "0")
      else
        # 0 in excess-four. The radix point does not move.
        exponent = "100"
      end
    else
      # Store the position of the radix in excess-four.
      exponent = (whole.to_s(base=2).length + 4).to_s(base=2)
    end

    mantissa = (whole > 0) ? whole.to_s(base=2) : ""
    mantissa << (fraction[-4, 4] || fraction)
    sign_bit = (float < 0) ? "1" : "0"

    (sign_bit + exponent + mantissa).ljust(8, "0")
  end

  def decode_floating_point(bitstring)
    sign_bit = bitstring[0..0]
    exponent = bitstring[1..3]
    mantissa = bitstring[4..7]

    # Read in the exponent using excess-four.
    radix_point = exponent.binary_to_decimal(4)

    # Shift the radix to the left.
    if radix_point <= 0
      whole = 0
      mantissa = mantissa.rjust(4 + radix_point.abs, "0")
    # Shift the radix to the right.
    else
      whole = mantissa[0, radix_point]
      whole = whole.binary_to_decimal
      mantissa = mantissa[radix_point..3]
    end

    fraction = fractional_binary_to_decimal(mantissa)
    result = whole + fraction

    (sign_bit == "0") ? result : -result
  end

  # Generates a decimal representation of a fractional
  # portion of a binary number.
  def fractional_binary_to_decimal(bitstring)
    fraction = 0.0
    precision = 2

    # Traverse the bitstring, each time adding
    # the fractional portion to our total and raising
    # the precision to the next power.
    bitstring.each_byte do |bit|
      fraction += bit.chr.to_f / precision
      precision *= 2
    end

    fraction
  end

  # Generates a binary representation of a fractional
  # portion of a decimal number.
  def fractional_decimal_to_binary(float)
    bitstring = ""
    fraction = float
    
    # Double the fractional portion continuously until we get a whole
    # or reach our desired limit. Each time, the whole will
    # be either 1 or 0 (which is used to build the bitstring).
    while !fraction.zero? and bitstring.length < 8 do
      fraction *= 2
      bitstring << fraction.floor.to_s
      fraction %= 1
    end

    bitstring
  end

end
