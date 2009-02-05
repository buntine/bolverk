require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::LoadFromMemory do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::LoadFromMemory.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

  end

end
