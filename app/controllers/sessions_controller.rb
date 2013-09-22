class SessionsController < ApplicationController
  # GET /auth/:provider/callback
  def create
    case auth_hash['provider'].downcase
    when 'twitter'
      redirect_to '/gifts/claimable'
    when 'coinbase'
      auth = parse_provider(auth_hash)
      coinbase = CoinbaseOauthorization.find_or_init_by_uid(auth[:uid])
      coinbase.update_attributes(auth)
      session[:coinbase] = coinbase
      redirect_to '/gifts/claimable'
    else
      redirect_to '/'
    end    
  end 
  
  # GET /sessions/destroy
  def destroy
    reset_session
    redirect_to '/'
  end
  
private
  def auth_hash
    env['omniauth.auth']
  end    

  def parse_provider(auth_hash)
    case auth_hash['provider'].downcase
    when 'coinbase'
      {
        uid: auth_hash['info']['id'],
        name: auth_hash['info']['name'],
        email: auth_hash['info']['email'],
        token: auth_hash['credentials']['token'],
        refresh_token: auth_hash['credentials']['refresh_token'],
        expires: auth_hash['credentials']['expires'],
        expires_at: auth_hash['credentials']['expires_at']
      }
    when 'twitter'
      {
        uid: auth_hash['uid'],
        name: auth_hash['info']['nickname']
      }
    end
  end
end