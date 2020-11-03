# frozen_string_literal: true

require 'rails_helper'

describe Transactions::ProcessCharge do
  subject(:service) { described_class.new(transaction: charge).call }

  let(:merchant) { create :merchant }
  let(:authorize) { create :authorize, merchant: merchant }
  let(:charge) do
    build(:charge, :pending, authorize: authorize, merchant: merchant, amount: 300)
  end

  before { create(:charge, authorize: authorize, status: :error) }

  it { expect { service }.to change(charge, :approved?).to(true) }
  it { expect { service }.to change(charge, :persisted?).to(true) }
  it { expect { service }.to change { merchant.reload.total_transaction_sum }.by(300) }

  context 'when transaction processing fails for some reason' do
    let(:charge) { build(:charge, :pending, amount: 0) }

    it { expect { service }.to raise_error(Service::Error) }
  end

  context 'when transaction is processed already' do
    let(:charge) { create(:charge) }

    it { expect { service }.not_to change { charge.reload.updated_at } }
    it { expect { service }.not_to change { merchant.reload.total_transaction_sum } }
  end

  context 'when authorize transaction has charge' do
    before { create(:charge, authorize: authorize) }

    it { expect { service }.to raise_error(described_class::DoubleChargeError) }
  end

  context 'when authorize is reversed' do
    let(:authorize) { create :authorize, status: :reversed, merchant: merchant }

    it { expect { service }.to raise_error(described_class::AuthorizeStateError) }
  end
end
