require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Print do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::Print.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.memory_write("33", "5A")
      @machine.memory_write("34", "59")
  
      @machine.load_program_into_memory("B1", [ 'D033', 'D034', 'C000' ])
      @machine.start_program "B1"
    end
  
    it "should print the correct values to stdout" do
      out1 = OutputCatcher.catch_out do
        @machine.perform_machine_cycle
      end

      out2 = OutputCatcher.catch_out do
        @machine.perform_machine_cycle
      end

      # NOTE: 5A = "Z" in ASCII.
      out1.should eql("Z\n")

      # NOTE: 59 = "Y" in ASCII.
      out2.should eql("Y\n")
    end

  end

end
