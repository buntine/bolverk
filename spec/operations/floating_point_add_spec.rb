require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::FloatingPointAdd do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::FloatingPointAdd.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("2", "59") # 1 and 1/8 (1.125) in hex.
      @machine.register_write("3", "54") # 1/2 (0.5) in hex.

      @machine.load_program_into_memory("B1", [ '6234', 'C000' ])
      @machine.start_program "B1"
    end

    it "should add registers 2 and 3, storing the value in register 4" do
      @machine.registers[4].should eql("00000000")
      @machine.perform_machine_cycle

      # NOTE: 59 (1.125) + 54 (0.5) = 0101110 (1.625 or 1 and 5/8)
      @machine.registers[4].should eql("01011101")
    end

    it "should raise error in the case of an overflow"

  end

  describe "when executing operation again" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("2", "41") # 1/16 (1.125) in hex.
      @machine.register_write("3", "31") # 1/32 (0.5) in hex.

      @machine.load_program_into_memory("B1", [ '6234', 'C000' ])
      @machine.start_program "B1"
    end

    it "should add registers 2 and 3, storing the value in register 4" do
      @machine.registers[4].should eql("00000000")
      @machine.perform_machine_cycle

      # NOTE: 41 (1.0625) + 31 (0.03125) = 0101110 (1.09375 or 3/31)
      @machine.registers[4].should eql("00110011")
    end

  end

end
