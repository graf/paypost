# frozen_string_literal: true

module Transactions
  class Refund < Transactions::Base
    belongs_to :charge,
               class_name: 'Transactions::Charge',
               foreign_key: :parent_transaction_id,
               inverse_of: :refunds

    validates :amount,
              numericality: { greater_than: 0 },
              presence: true

    validates :status,
              inclusion: %w[approved error],
              presence: true
  end
end
