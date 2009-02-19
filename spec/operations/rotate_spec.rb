require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Rotate do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::Rotate.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("3", "5A")
      @machine.register_write("4", "59")
  
      @machine.load_program_into_memory("B1", [ 'A302', 'A404', 'C000' ])
      @machine.start_program "B1"
    end
  
    it "should print the correct values to stdout" do
      @machine.registers[3].should eql("01011010") # 5A
      @machine.perform_machine_cycle

      @machine.registers[4].should eql("01011001") # 59
      @machine.perform_machine_cycle

      # NOTE: 5A ROTATE(2) = 10010110.
      @machine.registers[3].should eql("10010110")

      # NOTE: 59 ROTATE(4) = 10010101.
      @machine.registers[4].should eql("10010101")
    end

  end

end
