# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Charge::Presenter do
  subject(:presenter) { described_class.new(charge) }

  let(:charge) { create :charge }

  it { expect(presenter.amount).to eq(charge.amount) }
  it { expect(presenter.authorize).to eq(charge.authorize.uuid) }
  it { expect(presenter.to_partial_path).to eq('payments/charge') }
end
