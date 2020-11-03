# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Reverse::Presenter do
  subject(:presenter) { described_class.new(reverse) }

  let(:reverse) { create :reversal }

  it { expect(presenter.authorize).to eq(reverse.authorize.uuid) }
  it { expect(presenter.to_partial_path).to eq('payments/reverse') }
end
