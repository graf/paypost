# frozen_string_literal: true

module Api
  module V1
    module Payments
      class Presenter
        delegate :uuid,
                 :status,
                 to: :@transaction

        def initialize(transaction)
          @transaction = transaction
        end

        def processed_at
          @transaction.created_at
        end
      end
    end
  end
end
