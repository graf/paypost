# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Reverse
        class ProcessPaymentFactory
          class << self
            def create(merchant:, params:)
              ProcessPayment.new(
                user: merchant,
                params: params,
                policy: Reverse::Policy,
                service: Transactions::ProcessReversal,
                contract: Reverse::Contract,
                presenter: Reverse::Presenter
              )
            end
          end
        end
      end
    end
  end
end
