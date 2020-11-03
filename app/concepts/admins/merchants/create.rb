# frozen_string_literal: true

module Admins
  module Merchants
    class Create
      include Operation

      policy ApplicationPolicy
      contract ::Merchant

      def call
        authorize! policy.admin?
        validate_contract
        create_merchant
      end

      private

      def validate_contract
        return if contract.valid?

        errors.merge!(contract.errors)
        fail!
      end

      def create_merchant
        contract.save!
      end
    end
  end
end
