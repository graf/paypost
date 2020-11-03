# frozen_string_literal: true

module Admins
  module Merchants
    class Edit
      include Operation

      policy ApplicationPolicy
      contract ::Merchant

      def call
        authorize! policy.admin?
      end

      def contract
        @_contract ||= contract_klass.find(@params[:id])
      end
    end
  end
end
