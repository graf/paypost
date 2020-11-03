# frozen_string_literal: true

module Transactions
  class ProcessAuthorize
    include Service

    def initialize(transaction:)
      @transaction = transaction
    end

    def call
      return if @transaction.persisted?

      @transaction.transaction do
        approve_transaction
      end
    rescue StandardError => e
      raise Service::Error, e
    end

    private

    def approve_transaction
      @transaction.approved!
    end
  end
end
