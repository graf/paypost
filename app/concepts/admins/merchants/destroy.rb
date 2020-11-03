# frozen_string_literal: true

module Admins
  module Merchants
    class Destroy
      include Operation

      policy ApplicationPolicy
      contract ::Merchant

      def call
        authorize! policy.admin?
        destroy_merchant
      end

      private

      def contract
        @_contract ||= contract_klass.find_by(id: @params[:id])
      end

      def destroy_merchant
        return unless contract

        contract.destroy!
      rescue ActiveRecord::DeleteRestrictionError => e
        errors.add(:base, :dependent_transactions, message: e.message)
        fail!
      rescue ActiveRecord::RecordNotDestroyed => e
        errors.add(:base, :record_not_destroyed, message: e.message)
        fail!
      end
    end
  end
end
