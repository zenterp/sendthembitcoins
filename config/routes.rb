Sendthembitcoins::Application.routes.draw do
  mount ResqueWeb::Engine => "/resque_web"
  get 'ripple.txt', to: 'application#ripple_txt'

  namespace :bridgebase do
    get '/', to: 'onboard#home'
    get 'account', to: 'accounts#show'
  end
  
  namespace :api do
    get 'bridge', to: 'ripple/federation#bridge'
    get 'bridges/:destination/quote', to: 'ripple/federation#quote'
    get '/session/auth', to: 'sessions#index'
    post '/session/clear', to: 'sessions#clear'

    post '/ripple_bridges/:bitcoin_address', to: 'ripple_bridges#create'
    get '/ripple_bridges/:destination_tag', to: 'ripple_bridges#show'
   
    namespace :ripple do
      resources :bridge_invoices, only: :create
    end

    namespace :facebook do
      resources :friends do
        collection do
          get 'search'
        end
      end
      resources :gifts do
        member do
          post 'claim' 
        end
        collection do
          post 'claim_all'
        end
      end
    end

    namespace :twitter do
      resources :gifts do
        member do
          post 'claim'
        end
        collection do
          post 'claim_all'
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
