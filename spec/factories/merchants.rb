# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Merchant #{n}" }
    sequence(:email) { |n| "merchant#{n}@test.com" }
  end
end
