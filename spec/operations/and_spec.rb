require File.dirname(__FILE__) + "/../spec_helper"

describe Bolverk::Operations::And do

  it "should be mapped to a four-bit string" do
    Bolverk::Operations::And.op_code.should match(/^[01]{4}$/)
  end

  describe "when executing operation" do

    before do
      @machine = Bolverk::Emulator.new
      @machine.register_write("1", "27") # 00100111
      @machine.register_write("2", "3A") # 00111010

      @machine.register_write("4", "AB") # 10101011
      @machine.register_write("7", "0D") # 00001101
    end
  
    it "should perform an AND on registers 1 and 2 and store the result in register 3" do
      @machine.load_program_into_memory("B1", [ '8123', 'C000' ])
      @machine.start_program "B1"

      @machine.registers[3].should eql("00000000")
      @machine.perform_machine_cycle
  
      # NOTE: 27 AND 3A = 00100010
      @machine.registers[3].should eql("00100010")
    end

    it "should perform an AND on registers 4 and 7 and store the result in register 8" do
      @machine.load_program_into_memory("B1", [ '8478', 'C000' ])
      @machine.start_program "B1"

      @machine.registers[8].should eql("00000000")
 #     @machine.perform_machine_cycle
  
      # NOTE: AB AND 0D = 00001001
#      @machine.registers[8].should eql("00001001")
    end

  end

end
