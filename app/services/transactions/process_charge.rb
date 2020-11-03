# frozen_string_literal: true

module Transactions
  class ProcessCharge
    included Service
    DoubleChargeError = Class.new(Service::Error)
    AuthorizeStateError = Class.new(Service::Error)

    def initialize(transaction:)
      @transaction = transaction
      @merchant = transaction.merchant
    end

    def call
      return if @transaction.persisted?

      @transaction.authorize.with_lock do
        ensure_authorize
        process_transaction
        update_merchant
      end
    rescue Service::Error => e
      raise e
    rescue StandardError => e
      raise Service::Error, e
    end

    private

    def ensure_authorize
      ensure_authorize_approved
      ensure_single_charge
    end

    def ensure_single_charge
      return unless Transactions::Charge.approved.exists?(authorize: @transaction.authorize)

      raise DoubleChargeError
    end

    def ensure_authorize_approved
      return if @transaction.authorize.approved?

      raise AuthorizeStateError
    end

    def process_transaction
      approve_transaction
    end

    def approve_transaction
      @transaction.approved!
    end

    def update_merchant
      @merchant.increment_total_transaction_sum(@transaction.amount)
    end
  end
end
