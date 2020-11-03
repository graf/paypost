# frozen_string_literal: true

module NavigationHelper
  def nav_active?(controller: nil, action: nil)
    controller_matches = Array.wrap(controller).map(&:to_s).include?(params[:controller])
    return true if controller_matches && action.nil?

    controller_matches && Array.wrap(action).include?(params[:action])
  end
end
