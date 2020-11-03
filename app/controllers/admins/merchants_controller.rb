# frozen_string_literal: true

module Admins
  class MerchantsController < ApplicationController
    def index
      call_operation(Admins::Merchants::Index, user: current_admin) do |op|
        @presenter = op.presenter
      end
    end

    def new
      call_operation(Admins::Merchants::New, user: current_admin) do |op|
        @merchant = op.contract
      end
    end

    def edit
      call_operation(Admins::Merchants::Edit, user: current_admin, params: params) do |op|
        @merchant = op.contract
      end
    end

    def create
      call_operation(Admins::Merchants::Create, user: current_admin, params: merchant_params) do |op|
        op.success { redirect_to admins_merchants_path, flash: { success: t('controllers.create.flash.success') } }
        op.failure do
          @merchant = op.contract
          flash.now[:error] = t('controllers.create.flash.error')
          render :new
        end
      end
    end

    def update
      call_operation(Admins::Merchants::Update, user: current_admin, params: merchant_params) do |op|
        op.success { redirect_to admins_merchants_path, flash: { success: t('controllers.update.flash.success') } }
        op.failure do
          @merchant = op.contract
          flash.now[:error] = t('controllers.update.flash.error')
          render :edit
        end
      end
    end

    def destroy
      call_operation(Admins::Merchants::Destroy, user: current_admin, params: params) do |op|
        op.success { redirect_to admins_merchants_path, flash: { success: t('controllers.destroy.success') } }
        op.failure { redirect_to admins_merchants_path, flash: { error: op.errors.full_messages } }
      end
    end

    def merchant_params
      params.require(:merchant).permit(
        :id,
        :email,
        :name,
        :description
      )
    end
  end
end
