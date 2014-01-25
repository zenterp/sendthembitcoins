class Auth::CallbacksController < ApplicationController
  def facebook
    session[:auth] = { 
      provider: 'facebook',
      uid: auth_hash['uid']
      access_token: auth_hash['credentials']['token']
    }
    redirect_to '/escrows'
  end
  
  def linkedin
    session[:auth] = {
      provider: 'linkedin',
      uid: auth_hash['uid'],
      access_token: auth_hash['credentials']['token'],
      access_token_secret: auth_hash['credentials']['secret']
    }
    redirect_to '/escrows' 
  end

  def github
    session[:auth] = {
      provider: 'github',
      uid: auth_hash['uid'],
      access_token: auth_hash['credentials']['token']
    }
    redirect_to '/escrows'
  end

  def twitter
    session[:auth] = {
      provider: 'twitter',
      uid: auth_hash['uid'],
      access_token: auth_hash['credentials']['token'],
      access_token_secret: auth_hash['credentials']['secret']
    }
    redirect_to '/escrows'
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
