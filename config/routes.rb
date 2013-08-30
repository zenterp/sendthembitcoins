Sendthembitcoins::Application.routes.draw do
  root to: 'home#index'
  
  namespace :api do
    resources :invoices, only: :create
    resources :coinbase_payments, only: :create
    resources :sessions, only: :index
  end

  get '/twitter/gifts/new', to: 'gifts#new'
  post '/twitter/gifts', to: 'gifts#create'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'sessions/destroy', to: 'sessions#destroy'
  get 'sessions/show', to: 'sessions#show'
end
