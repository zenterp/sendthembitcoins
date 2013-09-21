class Api::UserController < ApplicationController
  def current
    render json: { user: current_user, session: session }
  end
end