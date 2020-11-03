# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < Api::V1::ApplicationController
      def create
        call_operation(Payments::Create, user: current_merchant, params: create_params) do |result|
          @payment = result.presenter
          result.success { render :create, status: :created }
          result.failure { render json: { errors: result.errors }, status: :unprocessable_entity }
        end
      end

      private

      def create_params
        params.permit(
          :uuid,
          :amount,
          :customer_email,
          :customer_phone,
          :charge,
          :authorize,
          :type
        )
      end
    end
  end
end
