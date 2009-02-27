require File.dirname(__FILE__) + "/spec_helper"

describe Bolverk::MainMemory do

  before do
    @main_memory = Bolverk::MainMemory.new
  end

  it "should have a pre-defined stack" do
    @main_memory.stack.should eql(['00000000'] * 256)
  end

  it "should be able to read index from stack using hexadecimal" do
    @main_memory.read("00").should eql("00000000")
    @main_memory.read("01").should eql("00000000")
    @main_memory.read("02").should eql("00000000")
  end

  it "should be able to read index from stack using binary" do
    @main_memory.read("00000000").should eql("00000000")
    @main_memory.read("00000001").should eql("00000000")
    @main_memory.read("00000010").should eql("00000000")
  end

  it "should raise error if memory address does not exist when reading (binary)" do
    lambda { @main_memory.read("111001100100") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

  it "should raise error if memory address does not exist when reading (hex)" do
    lambda { @main_memory.read("1AA") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

  it "should be able to store value in stack using hexadecimal" do
    @main_memory.write("01", "FF")
    @main_memory.read("01").should eql("11111111")
  end

  it "should be able to store value in stack using binary" do
    @main_memory.write("00000010", "11111110")
    @main_memory.read("02").should eql("11111110")
  end

  it "should raise error if memory location does not exist when writing (binary)" do
    lambda { @main_memory.write("111111100100", "FF") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

  it "should raise error if memory location does not exist when writing (hex)" do
    lambda { @main_memory.write("AB5", "FF") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

  it "should be able to read an instruction (two cells)" do
    @main_memory.read_instruction("E1").should eql("0000000000000000")
  end

  it "should be able to write instructions to the stack" do
    @main_memory.load_instructions("E1", [ "1122", "3AAA", "C000" ])

    # Make sure it has stored correctly.
    @main_memory.read_instruction("DF").should eql("0000000000000000")
    @main_memory.read_instruction("E1").should eql("0001000100100010")
    @main_memory.read_instruction("E3").should eql("0011101010101010")
    @main_memory.read_instruction("E5").should eql("1100000000000000")
    @main_memory.read_instruction("E7").should eql("0000000000000000")
  end

  it "should raise error if memory address does not exist when reading instruction" do
    lambda { @main_memory.read_instruction("1AA") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

  it "should raise error if memory location does not exist when writing instructions" do
    lambda { @main_memory.load_instructions("AB5", [ "FFFF" ]) }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

end 
