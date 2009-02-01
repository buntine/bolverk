module Bolverk; end

class Bolverk::NullProgramCounterError < Exception; end
class Bolverk::NullOpCodeError < Exception; end

require File.dirname(__FILE__) + "/lib/emulator"

