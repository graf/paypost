# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::ProcessPayment do
  subject(:operation) do
    described_class.new(
      user: double(merchant: double),
      params: {},
      policy: double(new: policy),
      contract: double(new: contract),
      service: double(new: processor),
      presenter: double(new: presenter)
    ).call
  end

  let(:policy) { double(create?: true) }
  let(:contract) { double(valid?: true, to_transaction: double) }
  let(:processor) { double(call: double) }
  let(:presenter) { double }

  it { is_expected.to be_kind_of(described_class) }
  it { is_expected.to be_success }
  it { expect(operation.presenter).to eq(presenter) }

  context 'when no authorized' do
    let(:policy) { double(create?: false) }

    it { expect { operation }.to raise_error(Operation::NotAuthorizedError) }

    it 'skips validation' do
      operation
    rescue Operation::NotAuthorizedError
      expect(contract).not_to have_received(:valid?)
    end

    it 'skips processing' do
      operation
    rescue Operation::NotAuthorizedError
      expect(processor).not_to have_received(:call)
    end
  end

  context 'when contract is not valid' do
    let(:errors) { ActiveModel::Errors.new(double) }
    let(:contract) { double(valid?: false, to_transaction: double(fail!: true), errors: errors) }

    it { expect(operation).to be_failed }
    it { is_expected.to be_kind_of(described_class) }
    it { expect(operation.presenter).to eq(presenter) }
  end

  context 'when operation execution fails' do
    let(:processor) { -> { raise Service::Error } }
    let(:errors) { ActiveModel::Errors.new(double) }
    let(:contract) { double(valid?: true, to_transaction: double(fail!: true), errors: errors) }

    it { expect(operation).to be_failed }
    it { is_expected.to be_kind_of(described_class) }
  end
end
