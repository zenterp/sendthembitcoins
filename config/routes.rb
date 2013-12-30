Sendthembitcoins::Application.routes.draw do
  get 'api', to: 'home#api_docs'
  
  namespace :api do
    get '/session/auth', to: 'sessions#index'
    post '/session/clear', to: 'sessions#clear'

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
  end

  root to: 'home#index'
  get '*path', to: 'home#index'
end
