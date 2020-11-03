# frozen_string_literal: true

module Admins
  class TransactionsController < ApplicationController
    def index
      call_operation(Admins::Transactions::Index, user: current_admin, params: params) do |op|
        @presenter = op.presenter
      end
    end
  end
end
