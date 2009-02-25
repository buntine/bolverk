require File.dirname(__FILE__) + "/spec_helper"

describe Bolverk::MainMemory do

  before do
    @main_memory = Bolverk::MainMemory.new
  end

  it "should have a pre-defined stack" do
    @main_memory.stack.should eql(['00000000'] * 256)
  end

  it "should be able to read index from stack using hexadecimal" do
    @stack.read("00").should eql("DA")
    @stack.read("01").should eql("29")
    @stack.read("02").should eql("00111110")
  end
#
#  it "should be able to read index from stack using binary" do
#    @stack.read("0000").should eql("DA")
#    @stack.read("0001").should eql("29")
#    @stack.read("0010").should eql("00111110")
#  end
#
#  it "should be able to store value in stack using hexadecimal" do
#    @stack.write("01", "FF")
#    @stack.should eql([ "DA", "FF", "00111110" ])
#  end
#
#  it "should be able to store value in stack using binary" do
#    @stack.write("0010", "11111110")
#    @stack.should eql([ "DA", "29", "11111110" ])
#  end

end 
