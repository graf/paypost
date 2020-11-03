# frozen_string_literal: true

module Transactions
  class Charge < Transactions::Base
    belongs_to :authorize,
               class_name: 'Transactions::Authorize',
               foreign_key: :parent_transaction_id,
               inverse_of: :charge

    has_many :refunds,
             class_name: 'Transactions::Refund',
             foreign_key: :parent_transaction_id,
             inverse_of: :charge,
             dependent: :destroy

    validates :amount,
              numericality: { greater_than: 0 },
              presence: true

    validates :status,
              inclusion: %w[approved refunded error],
              presence: true
  end
end
