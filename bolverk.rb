module Bolverk; end

class Bolverk::NullProgramCounterError < Exception; end
class Bolverk::UnknownOpCodeError < Exception; end

require File.dirname(__FILE__) + "/lib/emulator"

