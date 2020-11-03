# frozen_string_literal: true

module Merchants
  class ApplicationController < ApplicationController
    before_action :authenticate_merchant!
  end
end
