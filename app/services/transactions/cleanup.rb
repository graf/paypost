# frozen_string_literal: true

module Transactions
  class Cleanup
    include Service

    def initialize(before: 1.hour.ago)
      @before = before
    end

    def call
      Transactions::Base.where('created_at < ?', @before).destroy_all
    end
  end
end
