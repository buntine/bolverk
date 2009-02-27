require File.dirname(__FILE__) + "/spec_helper"

describe Bolverk::Registers do

  before do
    @registers = Bolverk::Registers.new
  end

  it "should have a pre-defined stack" do
    @registers.stack.should eql(['00000000'] * 16)
  end

  it "should be able to read index from stack using hexadecimal" do
    @registers.read("0").should eql("00000000")
    @registers.read("1").should eql("00000000")
    @registers.read("2").should eql("00000000")
  end

  it "should be able to read index from stack using binary" do
    @registers.read("0000").should eql("00000000")
    @registers.read("0001").should eql("00000000")
    @registers.read("0010").should eql("00000000")
  end

  it "should raise error if register does not exist when reading (binary)" do
    lambda { @registers.read("11100100") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

  it "should raise error if register does not exist when reading (hex)" do
    lambda { @registers.read("EA") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

  it "should be able to store value in stack using hexadecimal" do
    @registers.write("1", "FF")
    @registers.read("1").should eql("11111111")
  end

  it "should be able to store value in stack using binary" do
    @registers.write("0010", "11111110")
    @registers.read("2").should eql("11111110")
  end

  it "should raise error if register does not exist when writing (binary)" do
    lambda { @registers.write("11100100", "FF") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

  it "should raise error if register does not exist when writing (hex)" do
    lambda { @registers.write("B5", "FF") }.should raise_error(Bolverk::InvalidMemoryAddress)
  end

end
