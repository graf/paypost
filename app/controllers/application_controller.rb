# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Operation::ControllerHelpers

  rescue_from Operation::NotAuthorizedError do
    render plain: I18n.t('controllers.unauthorized'), status: :unauthorized
  end
end
