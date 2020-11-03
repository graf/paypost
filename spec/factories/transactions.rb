# frozen_string_literal: true

FactoryBot.define do
  factory :transaction, class: 'Transactions::Base' do
    merchant
    status { :approved }

    uuid { SecureRandom.uuid }
    sequence(:customer_email) { |n| "customer#{n}@test.com" }

    trait :pending do
      status { nil }
    end

    factory :authorize, class: 'Transactions::Authorize' do
      amount { 110 }
    end

    factory :charge, class: 'Transactions::Charge' do
      amount { 110 }
      authorize { association :authorize, merchant: merchant, created_at: created_at }
    end

    factory :refund, class: 'Transactions::Refund' do
      amount { 110 }
      charge { association :charge, status: :refunded, merchant: merchant, created_at: created_at }
    end

    factory :reversal, class: 'Transactions::Reversal' do
      authorize { association :authorize, status: :reversed, merchant: merchant, created_at: created_at }
    end
  end
end
