# frozen_string_literal: true

require 'rails_helper'

describe Admins::Merchants::Edit do
  subject(:operation) { described_class.call(user: admin, params: params) }

  let(:admin) { create :admin }
  let(:merchant) { create :merchant }
  let(:params) { { id: merchant.id } }

  it_behaves_like 'an operation'
  it_behaves_like 'an operation allowed for admin'

  it { expect(described_class.policy_klass).to eq(ApplicationPolicy) }
  it { expect(operation.contract).to be_kind_of(Merchant) }

  context 'when merchant does not exist' do
    let(:params) { { id: -1 } }

    it { expect { operation }.to raise_error(ActiveRecord::RecordNotFound) }
  end
end
