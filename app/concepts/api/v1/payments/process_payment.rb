# frozen_string_literal: true

module Api
  module V1
    module Payments
      class ProcessPayment
        include Operation

        cattr_accessor :service_klass

        # rubocop:disable Metrics/ParameterLists
        def initialize(policy:, contract:, service:, presenter:, user: nil, params: {})
          super(
            user: user,
            params: params,
            contract: contract,
            presenter: presenter
          )
          self.presenter_klass = presenter
          self.policy_klass = policy
          self.contract_klass = contract
          self.service_klass = service
        end
        # rubocop:enable Metrics/ParameterLists

        def call
          ActiveRecord::Base.transaction do
            check_permissions
            validate_contract
            call_service
          end
        ensure
          present(@transaction)
        end

        private

        def contract
          @_contract ||= contract_klass.new(merchant: @user, **@params)
        rescue ActiveModel::UnknownAttributeError => e
          fail_with_error(:unknown_attribute, attribute: e.attribute)
        end

        def check_permissions
          authorize! policy.create?
        end

        def validate_contract
          return if contract.valid?

          errors.merge!(contract.errors)

          fail! if errors.added?(:uuid, :not_unique) || errors.added?(:uuid, :invalid)

          transaction = contract.to_transaction
          transaction.fail!

          fail!
        end

        def call_service
          @transaction = contract.to_transaction
          processor = service_klass.new(transaction: @transaction)
          processor.call
        rescue Service::Error => e
          @transaction.fail!
          fail_with_error(:processor, message: e.message)
        end
      end
    end
  end
end
