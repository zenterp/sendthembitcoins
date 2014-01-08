class BridgebaseController < ApplicationController
  before_filter :verify_coinbase_session

  def verify_coinbase_session
    @coinbase_user = session[:coinbase]
    if !session[:coinbase]
      redirect_to '/auth/coinbase'
    end
  end
end
