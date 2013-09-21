class Api::AddressesController < ApplicationController
  def set_coinbase
    if session[:coinbase]
      coinbase_oauth = CoinbaseOauthorization.where(uid: session[:coinbase][:uid])[0]
      coinbase_oauth.try(:set_bitcoin_address)
      session[:coinbase] = coinbase_oauth
      render json: coinbase_oauth
    else
      render json: {}
    end
  end
end