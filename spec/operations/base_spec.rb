require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::Base do

  it "should provide helper for bit-string mapping" do
    Bolverk::Operations::Base.map_to "1000"

    Bolverk::Operations::Base.op_code.should eql("1000")
  end

  it "should return nil for op_code if nothing has been set" do
    Bolverk::Operations::Base.op_code.should be_nil
  end

  it "should store reference to the emulator" do
    emulator = Bolverk::Emulator.new
    operation = Bolverk::Operations::Base.new(emulator)

    operation.emulator.should eql(emulator)
  end

end
