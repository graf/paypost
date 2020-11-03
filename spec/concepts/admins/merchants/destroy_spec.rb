# frozen_string_literal: true

require 'rails_helper'

describe Admins::Merchants::Destroy do
  subject(:operation) { described_class.call(user: admin, params: params) }

  let(:admin) { create :admin }
  let!(:merchant) { create :merchant }
  let(:params) { { id: merchant.id } }

  it_behaves_like 'an operation'
  it_behaves_like 'an operation allowed for admin'
  it { expect { operation }.to change(Merchant, :count).by(-1) }

  context 'when merchant has transactions' do
    before { create :authorize, merchant: merchant }

    it { is_expected.to be_failed }
  end

  context 'when merchant does not exist' do
    let(:params) { { id: -1 } }

    it { is_expected.to be_success }
  end
end
