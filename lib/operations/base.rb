class Bolverk::Operations::Base
  include Bolverk::Operations::ClassMethods

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

end

Dir[File.dirname(__FILE__) + "/*.rb"].each do |file|
  require file
end
