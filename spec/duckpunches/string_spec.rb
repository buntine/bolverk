require File.dirname(__FILE__) + "/../spec_helper"

describe String do

  before do
    @bin = "001111011001"
    @hex = "3D9"
  end

  it "should be able to determine if string is binary data" do
    @bin.is_bitstring?.should be_true
    @hex.is_bitstring?.should be_false
  end

  it "should be able to determine if string is hexadecimal data" do
    @bin.is_hexadecimal?.should be_true # It is still valid hex.
    @hex.is_hexadecimal?.should be_true
    "Total War".is_hexadecimal?.should be_false
  end

  it "should be able to convert from binary to hexadecimal"
  it "should raise exception if string value is not binary"

  it "should be able to convert from hexadecimal to binary"
  it "should be able to pad binary to appropriate length"
  it "should raise exception if string value is not hexadecimal"

end

