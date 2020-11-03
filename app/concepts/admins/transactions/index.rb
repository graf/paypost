# frozen_string_literal: true

module Admins
  module Transactions
    class Index
      include Operation

      policy ApplicationPolicy
      presenter ::Transactions::ListPresenter

      def call
        authorize! policy.admin?
        transactions = load_transactions
      ensure
        present(transactions)
      end

      private

      def contract
        ::Transactions
      end

      def load_transactions
        scope = ::Transactions::Base.all.includes(:merchant)
        scope = scope.where(merchant_id: @params[:merchant_id]) if @params[:merchant_id]
        scope
      end
    end
  end
end
