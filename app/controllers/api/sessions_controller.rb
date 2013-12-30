class Api::SessionsController < ApplicationController
  def index
    render json: SessionAuth.oauth_access_tokens(session)
  end

  def clear
    SessionAuth.clear_access_tokens(session)
    render action: :index
  end
end
