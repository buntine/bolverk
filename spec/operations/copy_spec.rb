require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Copy do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::Copy.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("A", "55")

      @machine.load_program_into_memory("B1", [ '40A3', 'C000' ])
      @machine.start_program "B1"
    end

    it "should copy the value at register A into register 3" do
      @machine.registers[3].should eql("00000000")
      @machine.registers[10].should eql("01010101")

      @machine.perform_machine_cycle

      @machine.registers[3].should eql("01010101")
    end

  end

end
