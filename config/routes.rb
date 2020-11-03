Rails.application.routes.draw do
  devise_for :admins
  devise_for :merchants

  root to: 'home#index'

  namespace :admins do
    resources :merchants
    resources :transactions, only: [:index]
  end

  namespace :merchants do
    resources :transactions, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'Merchant', at: 'auth', controllers: {
        sessions: 'api/v1/sessions'
      }
      resources :payments, only: [:create]
    end
  end
end
