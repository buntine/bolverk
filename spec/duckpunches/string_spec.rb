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

  it "should be able to complement a bitstring" do
    data ="001101"
    data.complement!
    data.should eql("110010")
  end

  it "should raise exception is data to complement is not valid" do
    data = "balls to the walls"
    lambda { data.complement! }.should raise_error(RuntimeError)
  end

  it "should be able to increment a binary value" do
    # 13 to 14
    data = "00001101"
    data.increment!
    data.should eql("00001110")

    # 100 to 101
    data = "01100100"
    data.increment!
    data.should eql("01100101")
  end

  it "should raise exception if overflow occurs when incrementing" do
    # 255 to 256
    data = "11111111"
    lambda { data.increment! }.should raise_error(Bolverk::OverflowError)
  end

  it "should raise exception if data is invalid when incrementing" do
    data = "balls to the walls"
    lambda { data.increment! }.should raise_error(RuntimeError)
  end

  it "should be able to convert from binary to decimal" do
    # 50
    data = "00110010"
    data.binary_to_decimal.should eql(50)

    # 105
    data = "01101001"
    data.binary_to_decimal.should eql(105)
  end

  it "should be able to convert binary to decimal with an excess notation" do
    # 1 in excess-four notation
    data = "0101"
    data.binary_to_decimal(4).should eql(1)
  end

  it "should raise exception when converting to decimal if data is not valid" do
    data = "balls to the walls"
    lambda { data.binary_to_decimal }.should raise_error(RuntimeError)
  end

  it "should be able to convert from binary to hexadecimal" do
    data = "11100110"
    data.binary_to_hex.should eql("E6")
  end

  it "should be able to pad with leading zeroes when converting from binary to hexadecimal" do
    data = "00000110"
    data.binary_to_hex.should eql("06")
  end

  it "should raise exception if string value is not binary" do
    data = "BEHERIT"
    lambda { data.binary_to_hex }.should raise_error(RuntimeError)
    data = "10012"
    lambda { data.binary_to_hex }.should raise_error(RuntimeError)
  end

  it "should be able to convert from hexadecimal to binary" do
    data = "0B"
    data.hex_to_binary(8).should eql("00001011")
  end

  it "should default to 16 bits when converting from hexadecimal to binary" do
    data = "AB"
    data.hex_to_binary.should eql("0000000010101011")
  end

  it "should raise exception if string value is not hexadecimal" do
    data = "Cremation"
    lambda { data.hex_to_binary }.should raise_error(RuntimeError)
    data = "GB"
    lambda { data.hex_to_binary }.should raise_error(RuntimeError)
  end

end
