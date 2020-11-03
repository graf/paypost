# frozen_string_literal: true

module Operation
  class Error < StandardError
    attr_reader :message

    def initialize(message)
      super()
      @message = message
    end
  end
end
