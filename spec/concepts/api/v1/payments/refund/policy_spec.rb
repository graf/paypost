# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Refund::Policy do
  subject { described_class.new(merchant, request).create? }

  let(:merchant) { create :merchant }
  let(:charge) { create :charge, merchant: merchant }
  let(:request) do
    instance_double(
      'Api::V1::Payments::Refund::Contract',
      merchant: merchant,
      charge_transaction: charge
    )
  end

  it { is_expected.to be_truthy }

  context 'when merchant is inactive' do
    let(:merchant) { create :merchant, status: :inactive }

    it { is_expected.to be_falsey }
  end

  context 'when charge is from other merchant' do
    let(:charge) { create :charge }

    it { is_expected.to be_falsey }
  end

  context 'when request is from other merchant' do
    let(:request) { double(merchant: create(:merchant), charge_transaction: charge) }

    it { is_expected.to be_falsey }
  end
end
