class OauthCallbacksController < ApplicationController
  def facebook
    session[:facebook] = auth_hash['credentials']['token']
    redirect_to '/api/session/oauth'
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
