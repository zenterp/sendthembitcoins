class Api::PaymentsController < ApplicationController
  def notification
    render json: {
      callback: params
    }
  end
end