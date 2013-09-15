class SessionsController < ApplicationController
  # GET /auth/:provider/callback
  def create
    session[:providers] ||= []

    if !session[:providers].collect {|p| p[:name]}.include?(auth_hash['provider'])
      session[:providers].push(parse_provider(auth_hash))
    end

    if auth_hash['provider'].downcase == 'twitter'
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
    provider = {}
    case auth_hash['provider'].downcase
    when 'coinbase'
      provider[:uid] = auth_hash['info']['id']
      provider[:credentials] = auth_hash['credentials']
    when 'twitter'
      provider[:uid] = auth_hash['uid']
      provider[:username] = auth_hash['info']['nickname']
    end
    provider[:name] = auth_hash['provider']
    return provider
  end
end