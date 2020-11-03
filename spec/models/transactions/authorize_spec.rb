# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Authorize, type: :model do
  describe 'factory' do
    subject { create :authorize }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:customer_email) }
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to belong_to(:merchant).required(true) }

    context 'when uuid is not unique' do
      before { create :authorize }

      it { is_expected.to validate_uniqueness_of(:uuid) }
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:merchant).class_name('Merchant') }
    it { is_expected.to have_one(:charge).class_name('Transactions::Charge') }
    it { is_expected.to have_one(:reversal).class_name('Transactions::Reversal') }
  end

  describe 'fail!' do
    subject(:fail!) { model.fail! }

    let(:uuid) { 'test' }
    let(:model) { build(:authorize, uuid: uuid, amount: 0) }

    it { expect { fail! }.to change(model, :persisted?).to(true) }
    it { expect { fail! }.to change(model, :error?).to(true) }

    context 'when uuid is missing' do
      let(:uuid) { nil }

      it { expect { fail! }.to change(model, :persisted?).to(true) }
      it { expect { fail! }.to change(model, :uuid).to(kind_of(String)) }
    end
  end
end
