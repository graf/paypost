# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_merchant
      redirect_to merchants_transactions_path
    elsif current_admin
      redirect_to admins_merchants_path
    end
  end
end
