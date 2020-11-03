# frozen_string_literal: true

module Transactions
  class ProcessRefund
    include Service
    InsufficientFundsError = Class.new(Error)

    def initialize(transaction:)
      @transaction = transaction
      @merchant = transaction.merchant
    end

    def call
      return if @transaction.persisted?

      @transaction.charge.with_lock do
        ensure_funds_available
        approve_transaction
        update_charge
        update_merchant
      end
    rescue Error => e
      raise e
    rescue StandardError => e
      raise Error, e
    end

    private

    def ensure_funds_available
      return if @transaction.charge.remaining_amount >= @transaction.amount

      raise InsufficientFundsError
    end

    def approve_transaction
      @transaction.approved!
    end

    def update_charge
      @transaction.charge.refunded!
    end

    def update_merchant
      @merchant.increment_total_transaction_sum(-@transaction.amount)
    end
  end
end
