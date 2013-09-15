class Api::UserController < ApplicationController
  def current
    render json: current_user
  end
end