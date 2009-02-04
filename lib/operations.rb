module Bolverk::Operations

  def handler_for_op_code(op_code)
    Bolverk::Operations.constants.each do |operation|
      klass = Bolverk::Operations.const_get(operation)

      if klass.op_code.eql? op_code
        return klass
      end
    end

    return nil
  end

end

require File.dirname(__FILE__) + "/operations/base"
