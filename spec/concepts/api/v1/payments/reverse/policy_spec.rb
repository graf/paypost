# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Reverse::Policy do
  subject { described_class.new(merchant, request).create? }

  let(:merchant) { create :merchant }
  let(:request) { double(merchant: merchant, authorize_transaction: authorize) }
  let(:authorize) { create :authorize, merchant: merchant }

  it { is_expected.to be_truthy }

  context 'when authorize is from other merchant' do
    let(:authorize) { create :authorize }

    it { is_expected.to be_falsey }
  end
end
