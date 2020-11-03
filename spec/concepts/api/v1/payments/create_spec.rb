# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::Create do
  subject(:operation) { described_class.call(user: double, params: {}) }

  let(:processor) { double(call: processor_result) }
  let(:processor_result) { double(presenter: processor_result_presenter, success?: true) }
  let(:processor_result_presenter) { double }

  before do
    allow(Api::V1::Payments::ProcessPaymentFactory).to receive(:create).and_return(processor)
  end

  it { is_expected.to be_kind_of(described_class) }
  it { is_expected.to be_success }
  it { expect(operation.presenter).to eq(processor_result_presenter) }

  context 'when processing failed' do
    let(:errors) { double }
    let(:processor_result) do
      double(presenter: processor_result_presenter, success?: false, errors: errors)
    end

    it { is_expected.to be_kind_of(described_class) }
    it { is_expected.to be_failed }
    it { expect(operation.presenter).to eq(processor_result_presenter) }
    it { expect(operation.errors).to eq(errors) }
  end
end
