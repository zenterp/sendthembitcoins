class Api::Ripple::FederationController < ApplicationController
  def bridge
    @destination = params.require(:destination)
    @tag = RippleBridge.get_bitcoin_bridge(@destination)
    render json: bridge_json
  end 

  def bridge_json
    @account = ENV['RIPPLE_ACCOUNT']
    Hash.new.tap { |h|
      h[:result] = 'success'
      h[:federation_json] = Hash.new.tap { |fed|
        fed[:type] = 'federation_record'
        fed[:domain] = 'sendthembitcoins.com'
        fed[:destination] = "#{@account}?dt=#{@tag}"
        fed[:currencies] = [{ 
          currency: 'BTC',
          issuer: @account
        }]
      }
      h[:quote_url] = 'https://www.sendthembitcoins.com/bridge'
    }.to_json
  end
end

