Sendthembitcoins::Application.routes.draw do
  get 'api', to: 'home#api_docs'
  
  namespace :api do
    # gifts
    post 'user/gifts/:gift_id/claim', to: 'gifts#claim'
    post '/gifts/twitter', to: 'gifts#create'
    get '/user/gifts/claimable', to: 'gifts#claimable'

    # user
    get '/user', to: 'user#current'
    post '/addresses/coinbase', to: 'addresses#set_coinbase'

    # payment callbacks
    get '/payments/coinbase/notification', to: 'payments#notification'

    # set state of session with these environment variables
    post '/addresses/receive', to: 'addresses#receive'
    post '/addresses/return', to: 'addresses#return'
    post '/emails/receive', to: 'addresses#receive'
    post '/emails/return', to: 'addresses#return'
  end

  # session management
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'sessions/destroy', to: 'sessions#destroy'

  # client-side javascript app
  root to: 'home#index'
  get '*path', to: 'home#index'
end
