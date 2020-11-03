# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Payments::ProcessPaymentFactory do
  subject(:operation) { described_class.create(merchant: merchant, params: params) }

  let(:params) { { type: payment_type } }
  let(:merchant) { create :merchant }

  context 'when authorize' do
    let(:payment_type) { 'authorize' }

    it { is_expected.to be_kind_of(Api::V1::Payments::ProcessPayment) }
    it { expect(operation.policy_klass).to eq(Api::V1::Payments::Policy) }
    it { expect(operation.contract_klass).to eq(Api::V1::Payments::Authorize::Contract) }
    it { expect(operation.presenter_klass).to eq(Api::V1::Payments::Authorize::Presenter) }
    it { expect(operation.service_klass).to eq(Transactions::ProcessAuthorize) }
  end

  context 'when charge' do
    let(:payment_type) { 'charge' }

    it { is_expected.to be_kind_of(Api::V1::Payments::ProcessPayment) }
    it { expect(operation.policy_klass).to eq(Api::V1::Payments::Charge::Policy) }
    it { expect(operation.contract_klass).to eq(Api::V1::Payments::Charge::Contract) }
    it { expect(operation.presenter_klass).to eq(Api::V1::Payments::Charge::Presenter) }
    it { expect(operation.service_klass).to eq(Transactions::ProcessCharge) }
  end

  context 'when refund' do
    let(:payment_type) { 'refund' }

    it { is_expected.to be_kind_of(Api::V1::Payments::ProcessPayment) }
    it { expect(operation.policy_klass).to eq(Api::V1::Payments::Refund::Policy) }
    it { expect(operation.contract_klass).to eq(Api::V1::Payments::Refund::Contract) }
    it { expect(operation.presenter_klass).to eq(Api::V1::Payments::Refund::Presenter) }
    it { expect(operation.service_klass).to eq(Transactions::ProcessRefund) }
  end

  context 'when reverse' do
    let(:payment_type) { 'reverse' }

    it { is_expected.to be_kind_of(Api::V1::Payments::ProcessPayment) }
    it { expect(operation.policy_klass).to eq(Api::V1::Payments::Reverse::Policy) }
    it { expect(operation.contract_klass).to eq(Api::V1::Payments::Reverse::Contract) }
    it { expect(operation.presenter_klass).to eq(Api::V1::Payments::Reverse::Presenter) }
    it { expect(operation.service_klass).to eq(Transactions::ProcessReversal) }
  end

  context 'when unknown type' do
    let(:payment_type) { nil }

    it { expect { operation }.to raise_error(ArgumentError) }
  end
end
