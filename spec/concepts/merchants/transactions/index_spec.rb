# frozen_string_literal: true

require 'rails_helper'

describe Merchants::Transactions::Index do
  subject(:operation) do
    described_class.call(
      user: merchant,
      params: params,
      policy: double(new: policy),
      presenter: double(new: presenter)
    )
  end

  let(:presenter) { double }
  let(:policy) { double(merchant?: true) }
  let(:merchant) { create :merchant }
  let(:params) { {} }

  it_behaves_like 'an operation'
  it { expect(operation.presenter).to eq(presenter) }

  context 'when policy check failed' do
    let(:policy) { double(merchant?: false) }

    it { expect { operation }.to raise_error(Operation::NotAuthorizedError) }
  end
end
