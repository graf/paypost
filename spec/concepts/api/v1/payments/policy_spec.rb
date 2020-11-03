# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Policy do
  subject { described_class.new(merchant, request).create? }

  let(:request) { double(merchant: merchant, charge_transaction: charge) }
  let(:merchant) { create :merchant }
  let(:charge) { create :charge, merchant: merchant }

  it { is_expected.to be_truthy }

  context 'when merchant is inactive' do
    let(:merchant) { create :merchant, status: :inactive }

    it { is_expected.to be_falsey }
  end

  context 'when request is from other merchant' do
    let(:request) { double(merchant: create(:merchant), charge_transaction: charge) }

    it { is_expected.to be_falsey }
  end
end
