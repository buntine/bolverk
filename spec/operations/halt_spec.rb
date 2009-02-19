require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Halt do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::Jump.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.load_program_into_memory("A1", [ 'C000' ])
      @machine.start_program "A1"

      @machine.perform_machine_cycle
    end

    it "should clear the program counter" do
      @machine.program_counter.should be_nil
    end

    it "should clear the instruction register" do
      @machine.instruction_register.instruction.should eql("0000000000000000")
    end

  end

end
