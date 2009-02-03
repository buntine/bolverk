require File.dirname(__FILE__) + "/spec_helper"

describe Bolverk::Emulator do

  before do
    @null_memory = [ "0" * 8 ] * 256
  end

  describe "when instantiating" do

    before(:all) do
      @machine = Bolverk::Emulator.new
    end

    it "should setup 256 memory cells set to zero" do
      @machine.main_memory.should eql(@null_memory)
    end

    it "should setup 16 registers set to zero" do
      registers = [ "0" * 8 ] * 16
      @machine.registers.should eql(registers)
    end

  end

  describe "when loading a program into memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_program_into_memory("00", [ '3A06', '14E2', 'C000' ])
    end

    it "should modify main memory" do
      @machine.main_memory.should_not eql(@null_memory)
    end

    it "should only store binary data in main memory" do
      @machine.main_memory.each do |cell|
        cell.should match(/[0-1]{8}/)
      end
    end

    it "should encode the data correctly in main memory" do
      # NOTE: This is equivelant to [ A3, 06, 14, E2, C0, 00 ]
      encoded_program = ["00111010", "00000110", "00010100",
                         "11100010", "11000000", "00000000"]

      @machine.main_memory[0..5].should eql(encoded_program)
    end

    it "should leave the rest of main memory alone" do
      @machine.main_memory[6..255].should eql([ "0" * 8 ] * 250)
    end

    it "should raise exception if program is too large for memory"

    it "should raise exception if memory cell does not exist"

  end

  describe "when inserting a program into an arbitrary area of memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_program_into_memory("A0", [ '3A34', 'B4E2', 'C000' ])
    end

    it "should insert the program into the correct area of memory" do
      # NOTE: This is equivelant to [ A3, 34, B4, E2, C0, 00 ]
      encoded_program = ["00111010", "00110100", "10110100",
                         "11100010", "11000000", "00000000"]

      @machine.main_memory[160..165].should eql(encoded_program)
    end

    it "should leave the rest of main memory alone" do
      @machine.main_memory[0..159].should eql([ "0" * 8 ] * 160)
      @machine.main_memory[165..255].should eql([ "0" * 8 ] * 91)
    end

  end

  describe "when loading one value into memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_value_into_memory("A3", "BB")
    end

    it "should modify main memory" do
      @machine.main_memory.should_not eql(@null_memory)
    end

    it "should only store binary data in main memory" do
      @machine.main_memory.each do |cell|
        cell.should match(/[0-1]{8}/)
      end
    end

    it "should store the correct data in the correct location" do
      # NOTE: A3 is 163 in decimal.

      @machine.main_memory[163].should eql("10111011")
    end

    it "should leave the rest of main memory alone" do
      @machine.main_memory[0..162].should eql([ "0" * 8 ] * 163)
      @machine.main_memory[164..255].should eql([ "0" * 8 ] * 92)
    end

    it "should raise exception is memory location does not exist"

  end

  describe "when loading multiple values into memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_values_into_memory("A3", [ "BB", "CC", "23" ])
    end

    it "should modify main memory" do
      @machine.main_memory.should_not eql(@null_memory)
    end

    it "should only store binary data in main memory" do
      @machine.main_memory.each do |cell|
        cell.should match(/[0-1]{8}/)
      end
    end

    it "should store the correct data in the correct location" do
      # NOTE: A3 is 163 in decimal.

      @machine.main_memory[163..165].should eql([ "10111011", "11001100", "00100011" ])
    end

    it "should leave the rest of main memory alone" do
      @machine.main_memory[0..162].should eql([ "0" * 8 ] * 163)
      @machine.main_memory[166..255].should eql([ "0" * 8 ] * 90)
    end

    it "should warn when end of memory has been reached and data is lost"

    it "should raise exception is memory location does not exist"

  end

  describe "when fetching a value from memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_value_into_memory("A3", "B6")
    end

    it "should return the correct value" do
      # B6 is 10110110 in binary.

      @machine.fetch_value_from_memory("A3").should eql("10110110")
    end

    it "should return all zeroes from empty cell" do
      @machine.fetch_value_from_memory("13").should eql("00000000")
    end

    it "should raise exception if the memory cell does not exist"

  end

  describe "when initialising a program in memory" do

    before(:all) do
      @machine = Bolverk::Emulator.new
      @machine.load_program_into_memory("B1", [ '3A06', '14E2', 'C000' ])
      @machine.start_program "B1"
    end

    it "should initialise the program counter to the correct memory address" do
      @machine.program_counter.should eql("B1")
    end

  end

  describe "when performing a machine cycle" do

    before(:each) do
      @machine = Bolverk::Emulator.new
      @machine.load_program_into_memory("B1", [ '3A06', '14E2', 'C000' ])
      @machine.start_program "B1"
    end

    it "should read instruction into the instruction register" do
      # NOTE: We expect the first program instruction to be read into the instruction register: 3A06
      @machine.perform_machine_cycle
      @machine.instruction_register.should eql('0011101000000110')
    end

    it "should increment the program counter two places" do
      @machine.program_counter.should eql("B1")
      @machine.perform_machine_cycle
      @machine.program_counter.should eql("B3")
    end

    it "should execute correct operation according to op code"

    it "should raise exception if program has not been started" do
      @machine = Bolverk::Emulator.new
      lambda { @machine.perform_machine_cycle }.should raise_error(Bolverk::NullProgramCounterError)
    end

    it "should raise exception if op code doesn't exist" do
      # NOTE: There is no operation for F (15), hence the exception.

      @machine = Bolverk::Emulator.new
      @machine.load_program_into_memory("A1", [ 'FA06', 'F4E2', 'C000' ])
      @machine.start_program "A1"

      lambda { @machine.perform_machine_cycle }.should raise_error(Bolverk::UnknownOpCodeError)
    end
  end

end
