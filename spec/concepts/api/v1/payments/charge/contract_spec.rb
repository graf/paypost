# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Charge::Contract do
  subject(:contract) { described_class.new(params) }

  let(:params) do
    {
      amount: amount,
      merchant: merchant,
      uuid: uuid,
      customer_email: customer_email,
      customer_phone: customer_phone,
      authorize: authorize.uuid
    }
  end
  let(:amount) { 100 }
  let(:merchant) { create :merchant }
  let(:uuid) { 'test' }
  let(:customer_email) { 'customer@test.com' }
  let(:customer_phone) { '0123456789' }
  let(:authorize) { create(:authorize, amount: 100, merchant: merchant) }

  it { is_expected.to be_valid }

  describe 'to_transaction' do
    subject(:transaction) { contract.to_transaction }

    it { is_expected.to be_kind_of(Transactions::Charge) }
    it { expect(transaction.amount).to eq(100) }
    it { expect(transaction.merchant).to eq(merchant) }
    it { expect(transaction.uuid).to eq(uuid) }
    it { expect(transaction.customer_email).to eq(customer_email) }
    it { expect(transaction.customer_phone).to eq(customer_phone) }
  end

  context 'when amount is not a number' do
    let(:amount) { '100' }

    it { is_expected.to be_valid }

    context 'when amount is asdf' do
      let(:amount) { 'asdf' }

      it { is_expected.not_to be_valid }
    end
  end

  context 'when amount mismatch auth amount' do
    let(:authorize) { create(:authorize, amount: 110, merchant: merchant) }

    it { is_expected.not_to be_valid }
  end

  context 'when auth is not approved' do
    let(:authorize) { create(:authorize, amount: 110, merchant: merchant, status: :error) }

    it { is_expected.not_to be_valid }
  end
end
