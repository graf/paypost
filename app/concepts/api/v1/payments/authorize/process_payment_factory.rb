# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Authorize
        class ProcessPaymentFactory
          class << self
            def create(merchant:, params:)
              ProcessPayment.new(
                user: merchant,
                params: params,
                policy: Payments::Policy,
                service: Transactions::ProcessAuthorize,
                contract: Authorize::Contract,
                presenter: Authorize::Presenter
              )
            end
          end
        end
      end
    end
  end
end
