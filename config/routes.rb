Sendthembitcoins::Application.routes.draw do
  get 'api', to: 'home#api_docs'
  
  namespace :api do
    # gifts
    post 'user/gifts/:gift_id/claim', to: 'gifts#claim'
    post '/gifts/twitter', to: 'gifts#create'
    get '/user/gifts/claimable', to: 'gifts#claimable'

    # user
    get '/user', to: 'user#current'

    # payment callbacks
    get '/coinbase/payments/success', to: 'gifts#payment_success'
    get '/coinbase/payments/failure', to: 'gift#payment_failure'
  end

  # session management
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'sessions/destroy', to: 'sessions#destroy'

  # client-side javascript app
  root to: 'home#index'
  get '*path', to: 'home#index'
end
