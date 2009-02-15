module Bolverk::Operations

  # Searches through the implemented operations looking for the one which
  # matches the "op_code".
  def handler_for_op_code(op_code)
    consts = Bolverk::Operations.constants.reject { |const| const.eql?("Base") }

    consts.each do |operation|
      klass = Bolverk::Operations.const_get(operation)

      if klass.op_code.eql? op_code
        return klass
      end
    end

    return nil
  end

end

require File.dirname(__FILE__) + "/operations/base"
