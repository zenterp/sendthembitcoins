Sendthembitcoins::Application.routes.draw do
  root to: 'home#index'
  get 'api', to: 'home#api_docs'
  
  namespace :api do
    # gifts
    post 'user/gifts/:gift_id/claim', to: 'gifts#claim'
    post '/gifts/twitter', to: 'gifts#create'
    get '/user/gifts/claimable', to: 'gifts#claimable'

    # user
    get '/user', to: 'user#current'
  end

  # session management
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'sessions/destroy', to: 'sessions#destroy'
  get '*path', to: 'home#index'
end
