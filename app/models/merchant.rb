# frozen_string_literal: true

class Merchant < ApplicationRecord
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
end
