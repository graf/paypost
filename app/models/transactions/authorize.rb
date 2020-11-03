# frozen_string_literal: true

module Transactions
  class Authorize < Transactions::Base
    has_one :charge,
            class_name: 'Transactions::Charge',
            foreign_key: :parent_transaction_id,
            inverse_of: :authorize,
            dependent: :destroy

    has_one :reversal,
            class_name: 'Transactions::Reversal',
            foreign_key: :parent_transaction_id,
            inverse_of: :authorize,
            dependent: :destroy

    validates :amount,
              numericality: { greater_than: 0 },
              presence: true

    validates :status,
              inclusion: %w[approved reversed error],
              presence: true
  end
end
