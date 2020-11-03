# frozen_string_literal: true

require 'rails_helper'

describe Transactions::ProcessAuthorize do
  subject(:service) { described_class.new(transaction: transaction).call }

  let(:transaction) { build(:authorize, :pending) }

  it { expect { service }.to change(transaction, :approved?).to(true) }
  it { expect { service }.to change(transaction, :persisted?).to(true) }

  context 'when transaction processing fails' do
    let(:transaction) { build(:authorize, :pending, amount: 0) }

    it { expect { service }.to raise_error(Service::Error) }
  end
end
