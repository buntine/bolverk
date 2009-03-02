#! /usr/bin/env ruby

require 'rubygems'
require 'lib/bolverk'

machine = Bolverk::Emulator.new

program = [ '2122', '223A', '5123', '33F1', 'D1F1', 'E00A', 'C000' ]

machine.load_program_into_memory("A1", program)
machine.start_program("A1")

while true
  begin
    machine.perform_machine_cycle
  rescue Bolverk::NullProgramCounterError
    puts "--EOF--"
    break
  end
end
