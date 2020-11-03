# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Refund
        class ProcessPaymentFactory
          class << self
            def create(merchant:, params:)
              ProcessPayment.new(
                user: merchant,
                params: params,
                policy: Refund::Policy,
                service: Transactions::ProcessRefund,
                contract: Refund::Contract,
                presenter: Refund::Presenter
              )
            end
          end
        end
      end
    end
  end
end
