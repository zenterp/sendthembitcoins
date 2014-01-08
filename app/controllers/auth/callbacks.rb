class Auth::CallbacksController < ApplicationController
  def facebook
    session[:facebook] = auth_hash['credentials']['token']
    redirect_to '/api/session/auth'
  end
  
  def linkedin
    session[:linkedin] = auth_hash['credentials']
    redirect_to '/api/session/auth' 
  end

  def github
    session[:github] = auth_hash['credentials']['token']
    redirect_to '/api/session/auth'
  end

  def twitter
    session[:twitter] = auth_hash['credentials']
    redirect_to '/api/session/auth'
  end

  def coinbase
    coinbase = CoinbaseOauthorization.find_or_init_by_uid(auth_hash['info']['id'])
    coinbase.update_auth(auth_hash)
    session[:coinbase] = coinbase
    redirect_to '/bridgebase/account'
  end 

private

  def auth_hash
    env['omniauth.auth']
  end    
end
