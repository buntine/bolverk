require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::FloatingPointAdd do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::FloatingPointAdd.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    it "should add 1 1/8 and 1/2 and store the result in register 4" do
      # Setup program to run.
      @machine = Bolverk::Emulator.new
      @machine.register_write("2", "59") # 1 and 1/8 (1.125) in hex.
      @machine.register_write("3", "54") # 1/2 (0.5) in hex.
      @machine.load_program_into_memory("B1", [ '6234', 'C000' ])
      @machine.start_program "B1"
 
      @machine.registers[4].should eql("00000000")
      @machine.perform_machine_cycle

      # NOTE: 59 (1.125) + 54 (0.5) = 0101110 (1.625 or 1 and 5/8)
      @machine.registers[4].should eql("01011101")
    end

    it "should add 1/16 and 1/32 and store the result in register 4" do
      # Setup program to run.
      @machine = Bolverk::Emulator.new
      @machine.register_write("2", "41") # 1/16 (1.0625) in hex.
      @machine.register_write("3", "31") # 1/32 (0.03125) in hex.
      @machine.load_program_into_memory("B1", [ '6234', 'C000' ])
      @machine.start_program "B1"
 
      @machine.registers[4].should eql("00000000")
      @machine.perform_machine_cycle

      # NOTE: 41 (1.0625) + 31 (0.03125) = 0101110 (1.09375 or 3/32)
      @machine.registers[4].should eql("00110011")
    end

    it "should raise error in the case of an overflow" do
       # Setup program to run.
      @machine = Bolverk::Emulator.new
      @machine.register_write("2", "59") # 1 and 1/8 (1.125) in hex.
      @machine.register_write("3", "5C") # 1 and 1/2 (1.5) in hex.
      @machine.load_program_into_memory("B1", [ '6234', 'C000' ])
      @machine.start_program "B1"
 
      @machine.registers[4].should eql("00000000")

      # The emulator (annoyingly) cannot store 2 and 5/8 (requires atleast 9 bits), so this error must be raised.
      lambda { @machine.perform_machine_cycle }.should raise_error(Bolverk::OverflowError)
    end

  end

end
