class Bolverk::Operations::Base
  attr_reader :emulator

  def initialize(emulator)
    @emulator = emulator

    setup_instruction_parameters
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
      def self.layout
        layout
      end
    EOF
 
  end

  # Defaults to prevent NoMethodError.
  def self.op_code; nil; end
  def self.layout; [ [:parameter, 16] ]; end

 private

  def setup_instruction_parameters
    instruction = @emulator.instruction_register

    unless instruction.nil?
      instance_variable_set(:@register_a, instruction.operand(1))
      instance_variable_set(:@register_b, instruction.operand(2))
      instance_variable_set(:@destination, instruction.operand(3))
    end
  end

end

Dir[File.dirname(__FILE__) + "/*.rb"].each do |file|
  require file
end
