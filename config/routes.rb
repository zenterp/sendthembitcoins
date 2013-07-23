Sendthembitcoins::Application.routes.draw do
  root to: 'application#home'
  
  post 'api/invoices', to: 'application#create_invoice'
  post 'api/coinbase/payments', to: 'application#coinbase_payments'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'sessions/destroy', to: 'sessions#destroy'
  get 'sessions/show', to: 'sessions#show'
end
