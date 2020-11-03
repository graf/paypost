# frozen_string_literal: true

module Api
  module V1
    module Payments
      class ProcessPaymentFactory
        class << self
          def create(merchant:, params:)
            new(merchant: merchant, params: params).call
          end
        end

        def initialize(params:, merchant:)
          @merchant = merchant
          @params = params
        end

        def call
          factory = find_factory_by_type(@params.delete(:type))
          factory.create(
            params: @params,
            merchant: @merchant
          )
        end

        private

        def find_factory_by_type(type)
          case type
          when 'authorize', :authorize
            Authorize::ProcessPaymentFactory
          when 'charge', :charge
            Charge::ProcessPaymentFactory
          when 'refund', :refund
            Refund::ProcessPaymentFactory
          when 'reverse', :reverse
            Reverse::ProcessPaymentFactory
          else
            raise ArgumentError, "Unknown transaction type #{type}"
          end
        end
      end
    end
  end
end
