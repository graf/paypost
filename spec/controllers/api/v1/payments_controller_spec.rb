# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::PaymentsController, type: :controller do
  let(:merchant) { create :merchant }

  before { sign_in_merchant(merchant) }

  describe '#create' do
    before { allow(Api::V1::Payments::Create).to receive(:call).and_return(operation) }

    let(:params) do
      {
        type: :authorize,
        amount: 300,
        uuid: 'test',
        customer_email: 'customer@test.com',
        customer_phone: '0123456789'
      }
    end
    let(:operation) { double(presenter: double, errors: [], success: true, failure: true) }

    it do
      allow(operation).to receive(:success).and_yield

      post :create, params: params, format: :json
      is_expected.to permit(
        :uuid,
        :type,
        :customer_email,
        :customer_phone,
        :amount,
        :charge,
        :authorize
      ).for(:create)
      is_expected.to render_template(:create)
      expect(response).to have_http_status(:created)
    end

    context 'when failure' do
      it do
        allow(operation).to receive(:failure).and_yield

        post :create, params: params, format: :json
        expect(response.body).to eq('{"errors":[]}')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when action unauthorized' do
      before { allow(Api::V1::Payments::Create).to receive(:call).and_raise(Operation::NotAuthorizedError) }

      it do
        post :create, params: params, format: :json
        expect(response.body).to eq('{"errors":["You are not authorized to process this request"]}')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
