require File.dirname(__FILE__) + "/spec_helper"

describe Bolverk::Emulator do

  before do
    @null_memory = [ "0" * 8 ] * 256
  end

  describe "when instantiating" do

    before(:all) do
      @machine = Bolverk::Emulator.new
    end

    it "should setup 256 memory cells set to zero" do
      @machine.main_memory.should eql(@null_memory)
    end

    it "should setup 16 registers set to zero" do
      registers = [ "0" * 8 ] * 16
      @machine.registers.should eql(registers)
    end

  end

  describe "when loading a program into memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_program_into_memory([ '3A06', '14E2', 'C000' ])
    end

    it "should modify main memory" do
      @machine.main_memory.should_not eql(@null_memory)
    end

    it "should only store binary data in main memory" do
      @machine.main_memory.each do |cell|
        cell.should match(/[0-1]{8}/)
      end
    end

    it "should encode the data correctly in main memory" do
      # NOTE: This is equivelant to [ A3, 06, 14, E2, C0, 00 ]
      encoded_program = ["00111010", "00000110", "00010100",
                         "11100010", "11000000", "00000000"]

      @machine.main_memory[0..5].should eql(encoded_program)
    end

    it "should leave the rest of main memory alone" do
      @machine.main_memory[6..255].should eql([ "0" * 8 ] * 250)
    end

    it "should raise exception if program is too large for memory"

  end

  describe "when loading one value into memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_value_into_memory("A3", "BB")
    end

    it "should modify main memory" do
      @machine.main_memory.should_not eql(@null_memory)
    end

    it "should only store binary data in main memory" do
      @machine.main_memory.each do |cell|
        cell.should match(/[0-1]{8}/)
      end
    end

    it "should store the correct data in the correct location" do
      # NOTE: A3 is 163 in decimal.

      @machine.main_memory[163].should eql("10111011")
    end

    it "should leave the rest of main memory alone" do
      @machine.main_memory[0..162].should eql([ "0" * 8 ] * 163)
      @machine.main_memory[164..255].should eql([ "0" * 8 ] * 92)
    end

    it "should raise exception is memory location does not exist"

  end

  describe "when loading multiple values into memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_values_into_memory("A3", [ "BB", "CC", "23" ])
    end

    it "should modify main memory" do
      @machine.main_memory.should_not eql(@null_memory)
    end

    it "should only store binary data in main memory" do
      @machine.main_memory.each do |cell|
        cell.should match(/[0-1]{8}/)
      end
    end

    it "should store the correct data in the correct location" do
      # NOTE: A3 is 163 in decimal.

      @machine.main_memory[163..165].should eql([ "10111011", "11001100", "00100011" ])
    end

    it "should leave the rest of main memory alone" do
      @machine.main_memory[0..162].should eql([ "0" * 8 ] * 163)
      @machine.main_memory[166..255].should eql([ "0" * 8 ] * 90)
    end

    it "should warn when end of memory has been reached and data is lost"

    it "should raise exception is memory location does not exist"

  end

end
