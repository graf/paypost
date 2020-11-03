# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Refund::Contract do
  subject(:contract) { described_class.new(params) }

  let(:params) do
    {
      amount: amount,
      merchant: merchant,
      uuid: 'test',
      customer_email: 'customer@test.com',
      customer_phone: '0123456789',
      charge: charge.uuid
    }
  end
  let(:amount) { 100 }
  let(:merchant) { create :merchant }
  let(:charge) { create(:charge, amount: 100, merchant: merchant) }

  it { is_expected.to be_valid }

  describe 'to_transaction' do
    subject(:transaction) { contract.to_transaction }

    it { is_expected.to be_kind_of(Transactions::Refund) }
    it { expect(transaction.amount).to eq(100) }
    it { expect(transaction.merchant).to eq(merchant) }
    it { expect(transaction.uuid).to eq('test') }
    it { expect(transaction.customer_email).to eq('customer@test.com') }
    it { expect(transaction.customer_phone).to eq('0123456789') }
  end

  context 'when amount is not a number' do
    let(:amount) { '100' }

    it { is_expected.to be_valid }

    context 'when amount is asdf' do
      let(:amount) { 'asdf' }

      it { is_expected.not_to be_valid }
    end
  end

  context 'when amount mismatch charge amount' do
    let(:amount) { 150 }

    it { is_expected.not_to be_valid }
  end

  context 'when charge transaction has refund' do
    let(:charge) { create(:charge, amount: 100, status: :refunded, merchant: merchant) }
    let(:amount) { 50 }

    before { create(:refund, charge: charge, status: :approved, amount: 50) }

    it { is_expected.to be_valid }

    context 'when charge is fully refunded' do
      before { create(:refund, charge: charge, status: :approved, amount: 100) }

      it { is_expected.not_to be_valid }
    end
  end

  context 'when charge with error' do
    let(:charge) { create(:charge, amount: 100, status: :error, merchant: merchant) }

    it { is_expected.not_to be_valid }
  end
end
