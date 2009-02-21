require File.dirname(__FILE__) + "/../spec_helper"

describe String do

  before do
    @array = [ "DA", "29", "00111110" ]
  end

  it "should be able to read index from array using hexadecimal" do
    @array.read("00").should eql("DA")
    @array.read("01").should eql("29")
    @array.read("02").should eql("00111110")
  end

  it "should be able to read index from array using binary" do
    @array.read("0000").should eql("DA")
    @array.read("0001").should eql("29")
    @array.read("0010").should eql("00111110")
  end

  it "should be able to store value in array using hexadecimal" do
    @array.write("01", "FF")
    @array.should eql([ "DA", "FF", "00111110" ])
  end

  it "should be able to store value in array using binary" do
    @array.write("0010", "11111110")
    @array.should eql([ "DA", "29", "11111110" ])
  end

end 
