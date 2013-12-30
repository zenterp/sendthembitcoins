class CoinbaseAuthController < ApplicationController
  # GET /auth/coinbase/callback
  def create
    auth = parse_provider(env['omniauth.auth'])
    coinbase = CoinbaseOauthorization.find_or_init_by_uid(auth[:uid])
    coinbase.update_attributes(auth)
    session[:coinbase] = coinbase
  end 
  
  def parse_provider(auth_hash)
    {
      uid: auth_hash['info']['id'],
      name: auth_hash['info']['name'],
      email: auth_hash['info']['email'],
      token: auth_hash['credentials']['token'],
      refresh_token: auth_hash['credentials']['refresh_token'],
      expires: auth_hash['credentials']['expires'],
      expires_at: auth_hash['credentials']['expires_at']
    }
  end
end
