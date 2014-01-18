class Api::RippleBridgesController < ApplicationController
  # GET /api/ripple/bridges/ripple-to-bitcoin/:bitcoin_address
  def ripple_to_bitcoin
    destination_tag = RippleBridge.get_bitcoin_bridge(params[:bitcoin_address])
    render json: {
      success: true,
      rippleAddress: "#{ENV['RIPPLE_ACCOUNT']}?dt=#{destination_tag}"
    }.to_json
  end

  # GET /api/ripple/bridges/bitcoin-to-ripple/:destination_tag
  def bitcoin_to_ripple
    bridge = RippleBridge.find_by_destination_tag(params[:destination_tag])
    render json: bridge.to_json
  end
end
