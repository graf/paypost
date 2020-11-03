# frozen_string_literal: true

module Operation
  module ControllerHelpers
    def call_operation(opc, **args)
      result = opc.call(**args)
      if block_given?
        yield(result)
      else
        result
      end
    end
  end
end
