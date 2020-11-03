# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Reversal, type: :model do
  describe 'factory' do
    subject(:reversal) { create :reversal }

    it { is_expected.to be_valid }

    it 'and parent auth belong to the same merchant' do
      expect(reversal.merchant).to eq(reversal.authorize.merchant)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:customer_email) }
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to belong_to(:authorize).required(true) }
    it { is_expected.to belong_to(:merchant).required(true) }

    context 'when uuid is not unique' do
      before { create :reversal }

      it { is_expected.to validate_uniqueness_of(:uuid) }
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:authorize).class_name('Transactions::Authorize') }
    it { is_expected.to belong_to(:merchant).class_name('Merchant') }
  end
end
