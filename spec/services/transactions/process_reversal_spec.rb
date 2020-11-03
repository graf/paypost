# frozen_string_literal: true

require 'rails_helper'

describe Transactions::ProcessReversal do
  subject(:service) { described_class.new(transaction: reversal).call }

  let(:merchant) { create :merchant }
  let(:authorize) { create :authorize, merchant: merchant }
  let(:reversal) do
    build(:reversal, :pending, authorize: authorize, merchant: merchant)
  end

  before { create(:reversal, authorize: authorize, status: :error) }

  it { expect { service }.to change(reversal, :approved?).to(true) }
  it { expect { service }.to change(reversal, :persisted?).to(true) }
  it { expect { service }.to change(authorize, :reversed?).to(true) }

  context 'when transaction processing fails for some reason' do
    let(:authorize) { create :authorize, merchant: merchant }
    let(:reversal) { build(:reversal, :pending, authorize: authorize, customer_email: nil) }

    it { expect { service }.to raise_error(Service::Error) }
  end

  context 'when transaction is processed already' do
    let(:reversal) { create(:reversal) }

    it { expect { service }.not_to change { reversal.reload.updated_at } }
  end

  context 'when authorize transaction already reversed' do
    let(:authorize) { create :authorize, status: :reversed, merchant: merchant }

    it { expect { service }.to raise_error(described_class::AuthorizeIrreversibleError) }
  end

  context 'when authorize transaction has charge' do
    let(:charge) { create :charge, merchant: merchant }
    let(:authorize) { charge.authorize }

    it { expect { service }.to raise_error(described_class::AuthorizeIrreversibleError) }
  end

  context 'when authorize transaction has error' do
    let(:authorize) { create :authorize, status: :error, merchant: merchant }

    it { expect { service }.to raise_error(described_class::AuthorizeIrreversibleError) }
  end
end
