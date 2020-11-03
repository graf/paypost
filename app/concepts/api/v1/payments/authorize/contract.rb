# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Authorize
        class Contract < Payments::Contract
          include AmountAttribute

          def to_transaction
            Transactions::Authorize.new(
              uuid: uuid,
              amount: amount,
              customer_email: customer_email,
              customer_phone: customer_phone,
              merchant: merchant
            )
          end
        end
      end
    end
  end
end
