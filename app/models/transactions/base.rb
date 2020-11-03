# frozen_string_literal: true

module Transactions
  class Base < ApplicationRecord
    self.table_name = 'transactions'

    enum status: {
      pending: nil,
      approved: 'approved',
      reversed: 'reversed',
      refunded: 'refunded',
      error: 'error'
    }

    belongs_to :merchant

    validates :customer_email,
              presence: true
    validates :uuid,
              presence: true,
              uniqueness: true

    def fail!
      self.uuid ||= SecureRandom.uuid
      self.status = :error
      save!(validate: false)
    end
  end
end
