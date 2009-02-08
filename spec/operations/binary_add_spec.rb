require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::BinaryAdd do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::BinaryAdd.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    describe "when handling positive integers" do

      before do
        @machine = Bolverk::Emulator.new
        @machine.register_write("2", "22")
        @machine.register_write("3", "3A")
  
        @machine.load_program_into_memory("B1", [ '5234', 'C000' ])
        @machine.start_program "B1"
      end
  
      it "should add registers 2 and 3, storing the value in register 4" do
        @machine.registers[4].should eql("00000000")
        @machine.perform_machine_cycle
  
        # NOTE: 22 (34) + 3A (58) = 01011100 (92)
        @machine.registers[4].should eql("01011100")
      end

      it "should raise error in the case of an overflow"

    end
  
    describe "when handling negative integers" do

      before do
        @machine = Bolverk::Emulator.new
        @machine.register_write("5", "CD") # -51 in Two's Complement.
        @machine.register_write("6", "E4") # -28 in Two's Complement.
  
        @machine.load_program_into_memory("B1", [ '5567', 'C000' ])
        @machine.start_program "B1"
      end
 
      it "should add registers 5 and 6, storing the value in register 7" do
        @machine.registers[7].should eql("00000000")
        @machine.perform_machine_cycle
  
        # NOTE: CD (-51) + E4 (-28) = 10110001 (-79)
        @machine.registers[7].should eql("10110001")
      end

      it "should raise error in the case of an overflow"

    end

    describe "when handling both negative and positive integers" do

      before do
        @machine = Bolverk::Emulator.new
        @machine.register_write("2", "F0") # -16 in Two's Complement.
        @machine.register_write("3", "3C") # 60 in Two's Complement.
  
        @machine.load_program_into_memory("B1", [ '5235', 'C000' ])
        @machine.start_program "B1"
      end
 
      it "should add registers 2 and 3, storing the value in register 5" do
        @machine.registers[5].should eql("00000000")
        @machine.perform_machine_cycle
  
        # NOTE: F0 (-16) + 3C (60) = 00101100 (44)
        @machine.registers[5].should eql("00101100")
      end

      it "should raise error in the case of an overflow"

    end

  end

end
