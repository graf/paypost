# frozen_string_literal: true

require 'operation/errors/error'
require 'operation/errors/not_authorized_error'
require 'operation/controller_helpers'

module Operation
  module HookCall
    def call
      catch :fail! do
        tap { super }
      end
    end
  end

  # TODO: Remove ActiveSupport dependency if move to gem
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
    prepend HookCall

    class_attribute :policy_klass
    class_attribute :presenter_klass
    class_attribute :contract_klass

    attr_reader :presenter
  end

  module ClassMethods
    def call(**args)
      new(**args).tap(&:call)
    end

    def policy(value)
      self.policy_klass = value
    end

    def presenter(value)
      self.presenter_klass = value
    end

    def contract(value)
      self.contract_klass = value
    end
  end

  def initialize(user: nil, params: {}, contract: nil, policy: nil, presenter: nil)
    @user = user
    @params = params
    self.contract_klass = contract || contract_klass
    self.policy_klass = policy || policy_klass
    self.presenter_klass = presenter || presenter_klass
  end

  def success?
    return @operation_success if defined?(@operation_success)

    @operation_success = true
  end

  def failed?
    !success?
  end

  def fail!
    @operation_success = false
    throw :fail!, self
  end

  def success
    return unless success?

    yield(self)
  end

  def failure
    return if success?

    yield(self)
  end

  def fail_with_error(error, options = {})
    errors.add(:base, error, options)
    fail!
  end

  def contract
    @_contract ||= contract_klass.new(@params)
  rescue ActiveModel::UnknownAttributeError => e
    fail_with_error(:unknown_attribute, attribute: e.attribute)
  end

  private

  def policy
    @_policy ||= policy_klass.new(@user, contract)
  end

  def authorize!(value = nil)
    allowed = if block_given?
                yield
              else
                value
              end
    return if allowed

    raise Operation::NotAuthorizedError
  end

  def present(*args)
    @presenter = presenter_klass.new(*args)
  end
end
