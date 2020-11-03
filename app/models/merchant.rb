# frozen_string_literal: true

class Merchant < ApplicationRecord
  devise :database_authenticatable
  include DeviseTokenAuth::Concerns::User

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  has_many :transactions,
           class_name: 'Transactions::Base',
           dependent: :restrict_with_exception

  validates :email,
            presence: true,
            uniqueness: true
  validates :name,
            presence: true

  # rubocop:disable Rails/SkipsModelValidations
  # Valid Rails-way for atomic update numeric column
  def increment_total_transaction_sum(by)
    Merchant.update_counters(id, total_transaction_sum: by)
  end
  # rubocop:enable Rails/SkipsModelValidations
end
