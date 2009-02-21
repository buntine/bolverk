class Bolverk::Operations::BinaryAdd < Bolverk::Operations::Base

  map_to "0101"

  parameter_layout [ [:register_a, 4], [:register_b, 4], [:destination, 4] ]

  # Adds the values in register A and register B as if they were binary
  # numbers and stores the result in register C.
  #
  # Example:
  #   525A => 0101001001011010=> Add registers 2 and 5 together and store the result in register A.
  def execute
    operand_a = decode_twos_complement(@emulator.register_read(@register_a))
    operand_b = decode_twos_complement(@emulator.register_read(@register_b))

    result = operand_a + operand_b

    # Ensure the value can be encoded with 8-bits.
    if (-125..124).include?(result)
      @emulator.register_write(@destination, encode_twos_complement(result))
    else
      raise Bolverk::OverflowError, "Cannot store integer: #{result}"
    end
  end

 private

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

   def encode_twos_complement(number, size=8)
     bitstring = number.abs.to_s(base=2).rjust(size, "0")

     # Encode as negative value.
     if number < 0
       bitstring.complement!
       bitstring.increment!
     end

     bitstring
   end

end
