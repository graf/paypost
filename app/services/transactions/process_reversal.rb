# frozen_string_literal: true

module Transactions
  class ProcessReversal
    include Service
    AuthorizeIrreversibleError = Class.new(Error)

    def initialize(transaction:)
      @transaction = transaction
      @merchant = transaction.merchant
    end

    def call
      return if @transaction.persisted?

      @transaction.authorize.with_lock do
        ensure_authorize_reversible
        approve_transaction
        update_authorize
      end
    rescue Error => e
      raise e
    rescue StandardError => e
      raise Error, e
    end

    private

    def ensure_authorize_reversible
      irreversible =
        @transaction.authorize.charge ||
        @transaction.authorize.reversed? ||
        @transaction.authorize.error?
      return unless irreversible

      raise AuthorizeIrreversibleError
    end

    def approve_transaction
      @transaction.approved!
    end

    def update_authorize
      @transaction.authorize.reversed!
    end
  end
end
