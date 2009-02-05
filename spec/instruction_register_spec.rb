require File.dirname(__FILE__) + "/spec_helper"

describe Bolverk::InstructionRegister do

  before do
    @instruction_register = Bolverk::InstructionRegister.new "1111000011110000"
  end

  it "should store reader for instruction" do
    @instruction_register.instruction.should eql("1111000011110000")
  end

  it "should be able to return operation code (first 4 bits)" do
    @instruction_register.op_code.should eql("1111")
  end

  it "should be able to return the first operand (second 4 bits)" do
    @instruction_register.operand(1).should eql("0000")
  end

  it "should be able to return the second operand (third 4 bits)" do
    @instruction_register.operand(2).should eql("1111")
  end

  it "should be able to return the third operand (fourth 4 bits)" do
    @instruction_register.operand(3).should eql("0000")
  end

  it "should return the operation code (first 4 bits) by default" do
    @instruction_register.operand.should eql("1111")
  end

  it "should be able to update the instruction" do
    @instruction_register.update_with "1000111100111111"

    @instruction_register.instruction.should eql("1000111100111111")
    @instruction_register.op_code.should eql("1000")
  end

end
