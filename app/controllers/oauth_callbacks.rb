class OauthCallbacksController < ApplicationController
  def facebook
    render json: auth_hash
  end
  
  def linkedin
  end

  def github
  end

  def twitter
    session[:twitter] = auth_hash['info']['nickname']
    redirect_to '/api/session/auth'
  end

private

  def auth_hash
    env['omniauth.auth']
  end    
end
