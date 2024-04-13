Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: 'traders/dashboard#index', as: :authenticated_trader_root
    end
  end

  namespace :admins do
    get 'dashboard', to: 'dashboard#index'
  end

  namespace :traders do
    get 'dashboard', to: 'dashboard#index'
  end

  # Define root route for unauthenticated users (sign-in page)
  root to: 'devise/sessions#new'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
