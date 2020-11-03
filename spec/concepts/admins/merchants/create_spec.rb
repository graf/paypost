# frozen_string_literal: true

require 'rails_helper'

describe Admins::Merchants::Create do
  subject(:operation) { described_class.call(user: admin, params: params) }

  let(:params) do
    {
      email: email,
      name: 'Merchant Name',
      description: 'Description'
    }
  end
  let(:admin) { create :admin }
  let(:email) { 'merchant@test.com' }

  it_behaves_like 'an operation'
  it_behaves_like 'an operation allowed for admin'

  it { expect { operation }.to change(Merchant, :count).by(1) }
  it { expect(described_class.contract_klass).to eq(Merchant) }

  context 'when contract is not valid' do
    let(:email) { nil }

    it { is_expected.to be_failed }
    it { expect { operation }.not_to change(Merchant, :count) }
  end
end
