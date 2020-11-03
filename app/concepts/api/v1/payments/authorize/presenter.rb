# frozen_string_literal: true

module Api
  module V1
    module Payments
      module Authorize
        class Presenter < Payments::Presenter
          delegate :amount,
                   to: :@transaction

          def to_partial_path
            'payments/authorize'
          end
        end
      end
    end
  end
end
