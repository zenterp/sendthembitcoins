class Api::RippleBridgesController < ApplicationController
  # POST /api/ripple_bridges/:bitcoin_address
  def create
    bridge = RippleBridge.get_bitcoin_bridge(params[:bitcoin_address])
    render json: bridge.to_json
  end
end
