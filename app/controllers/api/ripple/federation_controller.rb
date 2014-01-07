class Api::Ripple::FederationController < ApplicationController
  def bridge
    @destination = params.require(:destination)
    @tag = RippleBridge.get_bitcoin_bridge(@destination)
    render json: bridge_json
  end 

  def bridge_json
    Hash.new.tap { |h|
      h[:result] = 'success'
      h[:federation_json] = Hash.new.tap { |fed|
        fed[:type] = 'federation_record'
        fed[:domain] = 'www.sendthembitcoins.com'    
        fed[:destination] = @tag
        fed[:currencies] = [{ 
          currency: 'BTC',
          issuer: ENV['RIPPLE_ACCOUNT']
        }]
      }
      h[:quote_url] = 'https://www.sendthembitcoins.com/bridge'
    }.to_json
  end
end

