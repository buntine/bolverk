require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::BinaryAdd do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::BinaryAdd.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("2", "53")
      @machine.register_write("3", "3A")

      @machine.load_program_into_memory("B1", [ '5234', 'C000' ])
      @machine.start_program "B1"
    end

    it "should add registers 2 and 3, storing the value in register 4" do
      @machine.registers[4].should eql("00000000")

      @machine.perform_machine_cycle

      # NOTE: 53 (83) + 3A (58) = 10001101 (141)
      @machine.registers[4].should eql("10001101")
    end

    it "should raise error in the case of an overflow"

  end

end
