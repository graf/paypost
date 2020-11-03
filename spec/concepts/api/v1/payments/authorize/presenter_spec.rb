# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Authorize::Presenter do
  subject(:presenter) { described_class.new(authorize) }

  let(:authorize) { create :authorize }

  it { expect(presenter.amount).to eq(authorize.amount) }
  it { expect(presenter.to_partial_path).to eq('payments/authorize') }
end
