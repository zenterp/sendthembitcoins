class Api::RippleBridgesController < ApplicationController
  # GET /api/ripple/bridges/ripple-to-bitcoin/:bitcoin_address
  def ripple_to_bitcoin
    bridge = RippleBridge.get_bitcoin_bridge(params[:bitcoin_address])
    render json: bridge.to_json
  end

  # GET /api/ripple/bridges/bitcoin-to-ripple/:destination_tag
  def bitcoin_to_ripple
    bridge = RippleBridge.find_by_destination_tag(params[:destination_tag])
    render json: bridge.to_json
  end
end
