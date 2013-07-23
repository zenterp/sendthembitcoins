class ApplicationController < ActionController::Base
  protect_from_forgery

  # GET / 
  def home
    @gifts = Gift.where(recipient_twitter_username: 'stevenzeiler').reject!{|g| g.funded_at.nil? }
  end 

  # POST /oauth/twitter
  def twitter_oauth_callback
  end 

  # POST /api/invoices
  def create_invoice
    @gift = Gift.create({
      recipient_twitter_username: params[:recipient_twitter_username],
      bitcoin_amount: params[:bitcoin_amount],
      coinbase_invoice_id: 'false'
    })
    
    @button = coinbase_client.create_button(
      "bitcoin gift to @#{params[:recipient_twitter_username]} on twitter", 
      @gift.bitcoin_amount.to_f * 1.01,
      nil, # description
      { gift_id: @gift.id }.to_json, # custom information
      { variable_price: true } # options
    )
      
    @gift.update_attributes(coinbase_invoice_id: @button['button']['code'])
    render json: JSON.parse(@gift.to_json).merge(invoice_button: @button)
  end 

  def coinbase_payments
    order = params['order']
    @gift = Gift.find(JSON.parse(order['custom'])['gift_id'])
  
    if order['status'] == 'completed'
      if @gift.coinbase_invoice_id == order['button']['id']
        @gift.update_attributes(funded_at: Time.now)   
      end 
    end 
  end 

private

  def coinbase_client
    @coinbase_client ||= Coinbase::Client.new(ENV['COINBASE_API_KEY'])
  end 
end
