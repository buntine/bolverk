require File.dirname(__FILE__) + "/spec_helper"

describe Bolverk::InstructionRegister do

  before do
    @instruction_register = Bolverk::InstructionRegister.new "1111000011000011"
  end

  it "should store reader for instruction" do
    @instruction_register.instruction.should eql("1111000011000011")
  end

  it "should be able to read in some bits in succession" do
    @instruction_register.read(4).should eql("0000")
    @instruction_register.read(4).should eql("1100")
    @instruction_register.read(4).should eql("0011")

    @instruction_register.rewind # Back to the first operand.

    @instruction_register.read(8).should eql("00001100")
    @instruction_register.read(4).should eql("0011")
  end

  it "should be able to return operation code (first 4 bits)" do
    @instruction_register.op_code.should eql("1111")
  end

  it "should be able to return the first operand (second 4 bits)" do
    @instruction_register.operand(1).should eql("0000")
  end

  it "should be able to return the second operand (third 4 bits)" do
    @instruction_register.operand(2).should eql("1100")
  end

  it "should be able to return the third operand (fourth 4 bits)" do
    @instruction_register.operand(3).should eql("0011")
  end

  it "should return the operation code (first 4 bits) by default" do
    @instruction_register.operand.should eql("1111")
  end

  it "should be able to update the instruction" do
    @instruction_register.update_with "1000111100111111"

    @instruction_register.instruction.should eql("1000111100111111")
    @instruction_register.op_code.should eql("1000")
  end

  it "should rewind the read position when the instruction is manually updated" do
    @instruction_register.read(12) # Read the whole thing.

    @instruction_register.update_with "1000111100111111"

    @instruction_register.read(12).should eql("111100111111") # Now it's back to the beginning.
  end

end
