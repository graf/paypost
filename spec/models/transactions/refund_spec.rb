# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Refund, type: :model do
  describe 'factory' do
    subject(:refund) { create :refund }

    it { is_expected.to be_valid }

    it 'and parent charge belong to the same merchant' do
      expect(refund.merchant).to eq(refund.charge.merchant)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:customer_email) }
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to belong_to(:charge).required(true) }
    it { is_expected.to belong_to(:merchant).required(true) }

    context 'when uuid is not unique' do
      before { create :refund }

      it { is_expected.to validate_uniqueness_of(:uuid) }
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:charge).class_name('Transactions::Charge') }
    it { is_expected.to belong_to(:merchant).class_name('Merchant') }
  end
end
