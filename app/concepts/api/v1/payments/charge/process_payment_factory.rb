# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Charge
        class ProcessPaymentFactory
          class << self
            def create(merchant:, params:)
              ProcessPayment.new(
                user: merchant,
                params: params,
                policy: Charge::Policy,
                service: Transactions::ProcessCharge,
                contract: Charge::Contract,
                presenter: Charge::Presenter
              )
            end
          end
        end
      end
    end
  end
end
