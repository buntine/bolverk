require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Store do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::Store.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("A", "55")

      @machine.load_program_into_memory("B1", [ '3AB9', 'C000' ])
      @machine.start_program "B1"
    end

    it "should store the value at register A in the memory cell B9" do
      @machine.registers[10].should eql("01010101")
      @machine.perform_machine_cycle

      # NOTE: Decimal 185 is B9 in hexadecimal.
      # NOTE: Decimal 10 is A in hexadecimal.
      # NOTE: Binary 01010101 is 55 in hexadecimal.
      @machine.registers[10].should eql("01010101")
      @machine.main_memory[185].should eql("01010101")
    end

  end

end
