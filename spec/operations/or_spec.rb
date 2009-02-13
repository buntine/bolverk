require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Or do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::Or.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("1", "27") # 00100111
      @machine.register_write("2", "3A") # 00111010
  
      @machine.load_program_into_memory("B1", [ '7123', 'C000' ])
      @machine.start_program "B1"
    end
  
    it "should perform an OR on registers 1 and 2 and store the result in register 3" do

      @machine.registers[3].should eql("00000000")
      @machine.perform_machine_cycle
  
      # NOTE: 27 OR 3A = 00111111
      @machine.registers[3].should eql("00111111")
    end

  end

end
