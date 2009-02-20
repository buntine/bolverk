# Setup namespace.
module Bolverk; end

# Setup custom exceptions.
class Bolverk::NullProgramCounterError < Exception; end
class Bolverk::UnknownOpCodeError < Exception; end
class Bolverk::InvalidOperandError < Exception; end
class Bolverk::InvalidMemoryAddress < Exception; end

# Begin the loading sequence.
require File.dirname(__FILE__) + "/duckpunches/string"
require File.dirname(__FILE__) + "/duckpunches/array"
require File.dirname(__FILE__) + "/operations"
require File.dirname(__FILE__) + "/bolverk/instruction_register"
require File.dirname(__FILE__) + "/bolverk/emulator"
