# frozen_string_literal: true

module Api
  module V1
    module Payments
      class Policy < ApplicationPolicy
        def initialize(merchant, payment)
          super
          @merchant = merchant
          @payment = payment
        end

        def create?
          merchant? &&
            merchant_active? &&
            payment_merchant_match?
        end

        private

        def merchant_active?
          @merchant.active?
        end

        def payment_merchant_match?
          @merchant == @payment.merchant
        end
      end
    end
  end
end
