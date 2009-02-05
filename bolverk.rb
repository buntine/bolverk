# Setup namespace.
module Bolverk; end

# Setup custom exceptions.
class Bolverk::NullProgramCounterError < Exception; end
class Bolverk::UnknownOpCodeError < Exception; end
class Bolverk::InvalidOperandError < Exception; end

# Begin the loading sequence.
require File.dirname(__FILE__) + "/lib/operations"
require File.dirname(__FILE__) + "/lib/instruction_register"
require File.dirname(__FILE__) + "/lib/emulator"
