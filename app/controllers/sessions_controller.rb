class SessionsController < ApplicationController
  def create
    session[:provider] = auth_hash['provider']
    auth_class = Object.const_get("Oauth").const_get("#{auth_hash['provider'].capitalize}")
    session[:uid] = auth_class.user_from_omniauth(auth_hash)[:uid]

    redirect_to '/sessions/show'
  end 
  
  # GET /sessions/destroy
  def destroy
    reset_session
    redirect_to '/sessions/show'
  end 
  
  # GET /sessions/show
  def show
    if session[:uid].present?
      render json: {
        session: { 
          uid: session[:uid],
          provider: session[:provider]
        }
      }
    else
      render json: { session: nil }
    end
  end 
  
  def auth_hash
    env['omniauth.auth']
  end 
    
end