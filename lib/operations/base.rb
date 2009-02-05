class Bolverk::Operations::Base
  attr_reader :emulator

  def initialize(emulator)
    @emulator = emulator
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

  # Default to prevent NoMethodError.
  def self.op_code
    nil
  end

end

Dir[File.dirname(__FILE__) + "/*.rb"].each do |file|
  require file
end
