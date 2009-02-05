require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::LoadFromValue do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::LoadFromValue.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new

      @machine.load_program_into_memory("B1", [ '2AFF', 'C000' ])
      @machine.start_program "B1"
    end

    it "should store the value at 06 in the register A" do
      @machine.perform_machine_cycle

      # NOTE: Decimal 10 is A in hexadecimal.
      # NOTE: Binary 11111111 is FF in hexadecimal.
      @machine.registers[10].should eql("11111111")
    end

  end

end
