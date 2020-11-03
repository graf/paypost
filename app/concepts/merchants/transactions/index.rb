# frozen_string_literal: true

module Merchants
  module Transactions
    class Index
      include Operation

      policy ApplicationPolicy
      presenter ::Transactions::ListPresenter

      def call
        authorize! policy.merchant?
        transactions = load_transactions
      ensure
        present(transactions)
      end

      private

      def contract
        ::Transactions::Base
      end

      def load_transactions
        @user.transactions.includes(:merchant)
      end
    end
  end
end
