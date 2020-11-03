# frozen_string_literal: true

module Admins
  module Merchants
    class Update
      include Operation

      policy ApplicationPolicy
      contract ::Merchant

      def call
        authorize! policy.admin?
        validate_contract
        create_merchant
      end

      private

      def contract
        return @_contract if defined?(@_contract)

        @_contract = contract_klass.find(@params.delete(:id))
        @_contract.assign_attributes(@params)
        @_contract
      rescue ActiveModel::UnknownAttributeError => e
        fail_with_error(:unknown_attribute, attribute: e.attribute)
      end

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
