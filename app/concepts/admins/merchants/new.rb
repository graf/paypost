# frozen_string_literal: true

module Admins
  module Merchants
    class New
      include Operation

      policy ApplicationPolicy
      contract ::Merchant

      def call
        authorize! policy.admin?
      end
    end
  end
end
