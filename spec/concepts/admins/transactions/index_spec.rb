# frozen_string_literal: true

require 'rails_helper'

describe Admins::Transactions::Index do
  subject(:operation) { described_class.call(user: admin, params: params, presenter: presenter) }

  let(:admin) { create :admin }
  let(:params) { {} }
  let(:presenter) { double(new: true) }
  let!(:authorize) { create :authorize }
  let!(:charge) { create :charge }

  it_behaves_like 'an operation'
  it_behaves_like 'an operation allowed for admin'
  it do
    operation
    expect(presenter).to have_received(:new).with(match_array([authorize, charge, charge.authorize]))
  end

  context 'when filtered by merchant_id' do
    let(:params) { { merchant_id: charge.merchant_id } }

    it do
      operation
      expect(presenter).to have_received(:new).with(match_array([charge, charge.authorize]))
    end
  end
end
