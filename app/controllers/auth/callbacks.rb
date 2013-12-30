class Auth::CallbacksController < ApplicationController
  def facebook
    session[:facebook] = auth_hash['credentials']['token']
    redirect_to '/api/session/oauth'
  end
  
  def linkedin
    render json: auth_hash
  end

  def github
    render json: auth_hash
  end

  def twitter
    session[:twitter] = auth_hash['info']['nickname']
    redirect_to '/api/session/auth'
  end

  def coinbase
    coinbase = CoinbaseOauthorization.find_or_init_by_uid(auth_hash['info']['id'])
    coinbase.update_auth(auth_hash)
    session[:coinbase] = coinbase
  end 

private

  def auth_hash
    env['omniauth.auth']
  end    
end
