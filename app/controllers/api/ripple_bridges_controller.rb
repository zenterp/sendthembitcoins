class Api::RippleBridgesController < ApplicationController
  # POST /api/ripple_bridges/:bitcoin_address
  def create
    bridge = RippleBridge.get_bitcoin_bridge(params[:bitcoin_address])
    render json: bridge.to_json
  end

  # GET /api/ripple_bridges/:destination_tag
  def show
    bridge = RippleBridge.find_by_destination_tag(params[:destination_tag])
    render json: bridge.to_json
  end
end
