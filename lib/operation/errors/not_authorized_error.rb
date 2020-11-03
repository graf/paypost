# frozen_string_literal: true

module Operation
  class NotAuthorizedError < Error
    def initialize
      super('You are not authorized to execute operation')
    end
  end
end
