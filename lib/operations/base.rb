class Bolverk::Operations::Base
  attr_reader :emulator

  def initialize(emulator)
    @emulator = emulator

    setup_instruction_parameters
  end

  def execute
    raise RuntimeError, "You need to override the execute method in the subclass."
  end

  # Helper method to map operations to bit-strings.
  # Example:
  #   class Bolverk::Operations::Badass < Bolverk::Operations::Base
  #     map_to "0110"
  #   end
  #   Bolverk::Operations::Badass.op_code ==> "0110"
  def self.map_to(op_code)
    self.class_eval <<-EOF
      def self.op_code
        "#{op_code}"
      end
    EOF
  end

  # Helper method to setup instance variables for instruction
  # parameters.
  def self.parameter_layout(layout)
    self.class_eval <<-EOF
      def layout
        #{layout.inspect}
      end
    EOF
  end

  # Defaults to prevent NoMethodError.
  def self.op_code; nil; end
  def layout; [ [:parameter, 12] ]; end

 private

  # This method will setup instance variables that are usable
  # within subclasses from the execute method. It delegates
  # bits from the instruction into variables to prevent boilerplate
  # code in every operation subclass.
  def setup_instruction_parameters
    instruction = @emulator.instruction_register
    unless instruction.nil?
      instruction.rewind

      layout.each do |param|
        bits = instruction.read(param[1])
        instance_variable_set("@#{param[0]}".intern, bits) unless param[0].eql?(:ignore)
      end
    end
  end

 protected

  # The following methods are used in multiple operations, thus I
  # feel this is the most appropriate place for them.

  # Reads in a binary string that is stored in twos-complement
  # notation and transforms it into a decimal integer.
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

  # Reads in a binary string that is stored in floating-point
  # notation and transforms it into a float.
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

end

Dir[File.dirname(__FILE__) + "/*.rb"].each do |file|
  require file
end
