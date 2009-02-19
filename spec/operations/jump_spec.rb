require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Jump do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::Jump.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("0", "5A")
      @machine.register_write("3", "5A")
      @machine.register_write("4", "15")
    end

    describe "performing jump" do 

      before do
        @machine.load_program_into_memory("A1", [ 'B3B2', 'C000' ])
        @machine.start_program "A1"
      end

      it "should jump the program counter" do
        @machine.program_counter.should eql("A1")
        @machine.perform_machine_cycle
        @machine.program_counter.should eql("B2")
      end

    end
  
    describe "not performing jump" do 

      before do
        @machine.load_program_into_memory("A1", [ 'B4C4', 'C000' ])
        @machine.start_program "A1"
      end

      it "should only increment the program counter" do
        @machine.program_counter.should eql("A1")
        @machine.perform_machine_cycle
        @machine.program_counter.should eql("A3") # Remember, each instruction requires two cells.
      end

    end
 
  end

end
