# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Refund
        class Contract < Payments::Contract
          include AmountAttribute

          attr_accessor :charge

          validates :charge, presence: true
          validate :validate_charge_state
          validate :validate_charge_amount

          def to_transaction
            Transactions::Refund.new(
              uuid: uuid,
              amount: amount,
              customer_email: customer_email,
              customer_phone: customer_phone,
              merchant: merchant,
              charge: charge_transaction
            )
          end

          def charge_transaction
            return @charge_transaction if defined?(@charge_transaction)

            @charge_transaction = Transactions::Charge.find_by(
              merchant: merchant,
              uuid: charge
            )
          end

          private

          def validate_charge_state
            return unless charge_transaction
            return if charge_transaction.approved? || charge_transaction.refunded?

            errors.add(:charge, :invalid_state)
          end

          def validate_charge_amount
            return unless charge_transaction
            return if charge_transaction.remaining_amount >= BigDecimal(amount)

            errors.add(:amount, :insufficient_funds)
          rescue ArgumentError
            errors.add(:amount, :not_a_number)
          end
        end
      end
    end
  end
end
