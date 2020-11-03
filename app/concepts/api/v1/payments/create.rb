# frozen_string_literal: true

module Api
  module V1
    module Payments
      class Create
        include Operation

        delegate :presenter,
                 :errors,
                 to: :@process_operation

        def call
          process_payment
        end

        private

        def process_payment
          @process_operation = ProcessPaymentFactory.create(
            merchant: @user,
            params: @params
          ).call
          return @process_operation if @process_operation.success?

          fail!
        end
      end
    end
  end
end
