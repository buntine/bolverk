require File.dirname(__FILE__) + "/spec_helper"

describe Bolverk::Emulator do

  describe "when instantiating" do

    before(:all) do
      @machine = Bolverk::Emulator.new
    end

    it "should setup 256 memory cells set to zero" do
      memory = [ "0" * 8 ] * 256
      @machine.main_memory.should eql(memory)
    end

    it "should setup 16 registers set to zero" do
      registers = [ "0" * 8 ] * 16
      @machine.registers.should eql(registers)
    end

  end

end
