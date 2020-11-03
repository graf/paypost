# frozen_string_literal: true

require 'rails_helper'

describe Merchants::TransactionsController, type: :controller do
  let(:merchant) { create :merchant }

  before { sign_in_merchant(merchant) }

  describe '#index' do
    before { allow(Merchants::Transactions::Index).to receive(:call).and_return(operation) }

    let(:operation) { double(presenter: double, success: true, failure: true) }

    it do
      allow(operation).to receive(:success).and_yield

      get :index
      is_expected.to render_template(:index)
      expect(response).to have_http_status(:success)
    end

    context 'when action unauthorized' do
      before { allow(Merchants::Transactions::Index).to receive(:call).and_raise(Operation::NotAuthorizedError) }

      it do
        get :index
        expect(response.body).to eq('You are not authorized to access this page')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
