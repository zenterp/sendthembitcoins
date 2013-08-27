class SessionsController < ApplicationController
  # GET /auth/:provider/callback
  def create
    session[:provider] = auth_hash['provider']
    session[:uid] = auth_class.user_from_omniauth(auth_hash)[:uid]
    session[:image] = auth_class.user_from_omniauth(auth_hash)[:image]
    redirect_to '/'
  end 
  
  # GET /sessions/destroy
  def destroy
    reset_session
    redirect_to '/'
  end

  # GET /sessions
  def index
    render json: {
      provider: (session[:provider].nil? ? nil : session[:provider])
    }.to_json
  end
  
private
  
  def auth_hash
    env['omniauth.auth']
  end 
  
  def auth_class
    Object.const_get("Oauth").const_get("#{auth_hash['provider'].capitalize}")
  end  
end