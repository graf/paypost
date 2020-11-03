# frozen_string_literal: true

module Service
  extend ActiveSupport::Concern

  Error = Class.new(StandardError)

  module ClassMethods
    def call(**args)
      new(**args).call
    end
  end
end
