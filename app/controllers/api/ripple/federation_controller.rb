class Api::Ripple::FederationController < ApplicationController
  def bridge
    @destination = params.require(:destination)
    @domain = params.require(:domain)
    @tag = RippleBridge.get_bitcoin_bridge(@destination)
    render json: bridge_json
  end 

  def quote
    @type = params.require(:type)
    @destination = params.require(:destination)
    @domain = params.require(:domain)
    @tag = RippleBridge.get_bitcoin_bridge(@destination)

    @amount, @currency = params.require(:amount).split("/")
    if @currency == 'BTC'
      render json: quote_json  
    else
      render text: @currency
    end
  end

  def quote_json
    @account = ENV['RIPPLE_ACCOUNT']
    {}.tap {|h|
      h[:result] = 'success'
      h[:quote] = {}.tap {|q|
        q[:destination_tag] = @tag
        q[:invoice_id] = SecureRandom.hex
        q[:send] = [
          { currency: 'BTC', value: @amount, issuer: @account } 
        ]
        q[:address] = @account
        q[:expires] = Time.now + 1.week
      }
    }
  end

  def bridge_json
    @account = ENV['RIPPLE_ACCOUNT']
    Hash.new.tap { |h|
      h[:result] = 'success'
      h[:federation_json] = Hash.new.tap { |fed|
        fed[:type] = 'federation_record'
        fed[:domain] = @domain
        fed[:destination] = @destination
        fed[:currencies] = [{ 
          currency: 'BTC',
          issuer: @account
        }]
        fed[:quote_url] = "https://www.sendthembitcoins.com/api/bridges/#{@destination}/quote"
      }
    }.to_json
  end
end

