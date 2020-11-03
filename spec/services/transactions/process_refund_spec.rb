# frozen_string_literal: true

require 'rails_helper'

describe Transactions::ProcessRefund do
  subject(:service) { described_class.new(transaction: refund).call }

  let(:merchant) { create :merchant }
  let(:charge) { create(:charge, merchant: merchant, amount: 300) }
  let(:refund) do
    build(:refund, :pending, merchant: merchant, charge: charge, amount: 100)
  end

  it { expect { service }.to change(refund, :approved?).to(true) }
  it { expect { service }.to change(refund, :persisted?).to(true) }
  it { expect { service }.to change(charge, :refunded?).to(true) }
  it { expect { service }.to change { merchant.reload.total_transaction_sum }.by(-100) }

  context 'when transaction processing fails for some reason' do
    let(:refund) { build(:refund, :pending, amount: 0) }

    it { expect { service }.to raise_error(Service::Error) }
  end

  context 'when transaction is processed already' do
    let(:refund) { create(:refund) }

    it { expect { service }.not_to change { refund.reload.updated_at } }
    it { expect { service }.not_to change { merchant.reload.total_transaction_sum } }
  end

  context 'when charge transaction has refund' do
    before { create(:refund, charge: charge, status: :approved, amount: 200) }

    it { expect { service }.to change { merchant.reload.total_transaction_sum }.by(-100) }

    context 'when charge is fully refunded' do
      before { create(:refund, charge: charge, status: :approved, amount: 300) }

      it { expect { service }.to raise_error(described_class::InsufficientFundsError) }
    end
  end
end
