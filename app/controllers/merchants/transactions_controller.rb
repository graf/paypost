# frozen_string_literal: true

module Merchants
  class TransactionsController < ApplicationController
    def index
      call_operation(Merchants::Transactions::Index, user: current_merchant, params: params) do |op|
        @presenter = op.presenter
      end
    end
  end
end
