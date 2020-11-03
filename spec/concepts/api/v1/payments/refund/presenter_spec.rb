# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Refund::Presenter do
  subject(:presenter) { described_class.new(refund) }

  let(:refund) { create :refund }

  it { expect(presenter.amount).to eq(refund.amount) }
  it { expect(presenter.charge).to eq(refund.charge.uuid) }
  it { expect(presenter.to_partial_path).to eq('payments/refund') }
end
