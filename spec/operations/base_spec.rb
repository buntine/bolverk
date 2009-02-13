require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Base do

  it "should provide helper for bit-string mapping" do
    Bolverk::Operations::Base.map_to "1000"

    Bolverk::Operations::Base.op_code.should eql("1000")
  end

  it "should store reference to the emulator" do
    emulator = Bolverk::Emulator.new
    operation = Bolverk::Operations::Base.new(emulator)

    operation.emulator.should eql(emulator)
  end

  describe "setting up parameter layouts" do

    before do
      Bolverk::Operations::Base.parameter_layout([ [:para1, 4], [:para2, 8] ])

      @emulator = Bolverk::Emulator.new
      @operation = Bolverk::Operations::Base.new(@emulator)

      @instructon_register = mock("InstructionRegister", :read => "1111")
      @emulator.stub!(:instruction_register).and_return(@instruction_register)
    end

    it "should accept custom parameter layout" do
      @operation.layout.should eql([ [:para1, 4], [:para2, 8] ])
    end

  end

end
