# frozen_string_literal: true

module Api
  module V1
    module Payments
      module AmountAttribute
        extend ActiveSupport::Concern

        attr_accessor :amount

        included do
          validates :amount,
                    numericality: { greater_than: 0 },
                    presence: true
        end
      end
    end
  end
end
