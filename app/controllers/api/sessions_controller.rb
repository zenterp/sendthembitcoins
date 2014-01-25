class Api::SessionsController < ApplicationController
  def index
    render json: session[:auth]
  end

  def clear
    session[:auth] = nil
    render action: :index
  end
end
