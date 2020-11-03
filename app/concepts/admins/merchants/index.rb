# frozen_string_literal: true

module Admins
  module Merchants
    class Index
      include Operation

      policy ApplicationPolicy
      presenter ListPresenter

      def call
        authorize! policy.admin?
        merchants = load_merchants
      ensure
        present(merchants)
      end

      private

      def contract
        ::Merchant
      end

      def load_merchants
        ::Merchant.order(created_at: :desc).all
      end
    end
  end
end
