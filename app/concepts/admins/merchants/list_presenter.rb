# frozen_string_literal: true

module Admins
  module Merchants
    class ListPresenter
      def initialize(merchants)
        @merchants = merchants
      end

      def merchants
        @_merchants ||= @merchants.map do |m|
          merchant(m)
        end
      end

      private

      def merchant(merchant)
        {
          id: merchant.id,
          email: merchant.email,
          name: merchant.name,
          balance: merchant.total_transaction_sum,
          created_at: merchant.created_at,
          description: merchant.description
        }
      end
    end
  end
end
