# frozen_string_literal: true

class ApplicationPolicy
  def initialize(user, _object)
    @user = user
  end

  def merchant?
    @user.is_a?(Merchant)
  end
end
