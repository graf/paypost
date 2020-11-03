# frozen_string_literal: true

module DeviseTokenAuth
  module Test
    module ControllerHelpers
      def sign_in_merchant(merchant)
        @request.env['devise.mapping'] = Devise.mappings[:merchant]
        @request.headers.merge! merchant.create_new_auth_token
        sign_in merchant
      end
    end
  end
end
