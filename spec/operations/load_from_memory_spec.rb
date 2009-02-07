require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::LoadFromMemory do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::LoadFromMemory.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new

      @machine.memory_write("06", "55")
      @machine.load_program_into_memory("B1", [ '1A06', 'C000' ])
      @machine.start_program "B1"
    end

    it "should store the value at 06 in the register A" do
      @machine.perform_machine_cycle

      # NOTE: Decimal 10 is A in hexadecimal.
      # NOTE: Binary 01010101 is 55 in hexadecimal.
      @machine.registers[10].should eql("01010101")
    end

  end

end
