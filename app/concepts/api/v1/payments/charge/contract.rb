# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Charge
        class Contract < Payments::Contract
          include AmountAttribute

          attr_accessor :authorize

          validates :authorize, presence: true
          validate :validate_authorize_approved
          validate :validate_authorize_amount

          def to_transaction
            Transactions::Charge.new(
              uuid: uuid,
              amount: amount,
              customer_email: customer_email,
              customer_phone: customer_phone,
              merchant: merchant,
              authorize: authorize_transaction
            )
          end

          def authorize_transaction
            return @authorize_transaction if defined?(@authorize_transaction)

            @authorize_transaction = Transactions::Authorize.find_by(
              merchant: merchant,
              uuid: authorize
            )
          end

          private

          def validate_authorize_approved
            return unless authorize_transaction
            return if authorize_transaction.approved?

            errors.add(:authorize, :invalid_state)
          end

          def validate_authorize_amount
            return unless authorize_transaction
            return if authorize_transaction.amount == BigDecimal(amount)

            errors.add(:amount, :invalid)
          rescue ArgumentError
            errors.add(:amount, :not_a_number)
          end
        end
      end
    end
  end
end
