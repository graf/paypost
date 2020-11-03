# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include Operation::ControllerHelpers
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_merchant!

      rescue_from Operation::NotAuthorizedError do
        render json: { errors: [I18n.t('controllers.api.v1.unauthorized')] }, status: :unauthorized
      end
    end
  end
end
