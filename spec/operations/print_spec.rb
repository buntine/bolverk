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

      @machine.memory_write("43", "22")
      @machine.memory_write("44", "AB")

      @machine.memory_write("53", "6B")
      @machine.memory_write("54", "BC")
    end
  
    it "should print the correct ASCII values to stdout" do
      @machine.load_program_into_memory("B1", [ 'D033', 'D034', 'C000' ])
      @machine.start_program "B1"

      out1 = OutputCatcher.catch_out do
        @machine.perform_machine_cycle
      end

      out2 = OutputCatcher.catch_out do
        @machine.perform_machine_cycle
      end

      # NOTE: 5A = "Z" in ASCII.
      out1.should eql("Z")

      # NOTE: 59 = "Y" in ASCII.
      out2.should eql("Y")
    end

    it "should print out the correct decimal equivelant of a binary number" do
      @machine.load_program_into_memory("B1", [ 'D143', 'D144', 'C000' ])
      @machine.start_program "B1"

      out1 = OutputCatcher.catch_out do
        @machine.perform_machine_cycle
      end

      out2 = OutputCatcher.catch_out do
        @machine.perform_machine_cycle
      end

      # NOTE: 22 = 34 in decimal.
      out1.should eql("34")

      # NOTE: AB = -85 in ASCII.
      out2.should eql("-85")
    end

    it "should print out the correct decimal equivelant of a floating-point number" do
      @machine.load_program_into_memory("B1", [ 'D253', 'D254', 'C000' ])
      @machine.start_program "B1"

      out1 = OutputCatcher.catch_out do
        @machine.perform_machine_cycle
      end

      out2 = OutputCatcher.catch_out do
        @machine.perform_machine_cycle
      end

      # NOTE: 6B = 2.75 in decimal.
      out1.should eql("2.75")

      # NOTE: BC = -0.375 in decimal.
      out2.should eql("-0.375")
    end

  end

end
