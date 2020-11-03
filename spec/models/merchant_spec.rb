# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'factory' do
    subject { create :merchant }

    it('is valid') { is_expected.to be_valid }
  end

  describe 'validations' do
    subject(:merchant) { build(:merchant) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }

    it do
      expect(merchant).to define_enum_for(:status).with_values(
        active: 'active',
        inactive: 'inactive'
      ).backed_by_column_of_type(:enum)
    end
  end

  describe 'relations' do
    it { is_expected.to have_many(:transactions) }
  end
end
