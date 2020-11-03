# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Refund
        class Policy < Payments::Policy
          def create?
            super && charge_merchant_match?
          end

          private

          def charge_merchant_match?
            @payment.charge_transaction&.merchant == @payment.merchant
          end
        end
      end
    end
  end
end
