# frozen_string_literal: true

module Transactions
  class Reversal < Transactions::Base
    belongs_to :authorize,
               class_name: 'Transactions::Authorize',
               foreign_key: :parent_transaction_id,
               inverse_of: :reversal

    validates :status,
              inclusion: %w[approved error],
              presence: true
  end
end
