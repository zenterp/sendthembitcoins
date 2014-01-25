Sendthembitcoins::Application.routes.draw do
  mount ResqueWeb::Engine => "/resque_web"
  get 'ripple.txt', to: 'application#ripple_txt'

  namespace :bridgebase do
    get '/', to: 'onboard#home'
    get 'account', to: 'accounts#show'
    get '/logout', to: 'accounts#logout'
  end
  
  namespace :api do
    get 'bridge', to: 'ripple/federation#bridge'
    get 'bridges/:destination/quote', to: 'ripple/federation#quote'
    get '/session/auth', to: 'sessions#index'
    post '/session/clear', to: 'sessions#clear'

    get '/ripple/bridges/ripple-to-bitcoin/:bitcoin_address', to: 'ripple_bridges#ripple_to_bitcoin'
    get '/ripple/bridges/bitcoin-to-ripple/:destination_tag', to: 'ripple_bridges#bitcoin_to_ripple'
   
    namespace :ripple do
      resources :bridge_invoices, only: :create
    end

    namespace :facebook do
      resources :friends do
        collection do
          get 'search'
        end
      end
    end

    post '/payments/coinbase/notification', to: 'payments#notification'
  end

  namespace :auth do
    get 'facebook/callback', to: 'callbacks#facebook'
    get 'twitter/callback', to: 'callbacks#twitter'
    get 'github/callback', to: 'callbacks#github'
    get 'linkedin/callback', to: 'callbacks#linkedin'
    get 'coinbase/callback', to: 'callbacks#coinbase'
  end

  root to: 'application#index'
  get '*path', to: 'application#index'
  get 'api', to: 'application#api_docs'
end
