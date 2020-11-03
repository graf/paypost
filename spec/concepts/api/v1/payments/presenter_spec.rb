# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Presenter do
  subject(:presenter) { described_class.new(reverse) }

  let(:reverse) { create :reversal }

  it { expect(presenter.uuid).to eq(reverse.uuid) }
  it { expect(presenter.status).to eq(reverse.status) }
  it { expect(presenter.processed_at).to eq(reverse.created_at) }
end
