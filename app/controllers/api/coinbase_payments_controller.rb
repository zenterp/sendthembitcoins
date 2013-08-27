class Api::CoinbasePaymentsController < ApplicationController
  # POST /api/coinbase_payments
  def create
    order = params['order']
    @gift = Gift.find(JSON.parse(order['custom'])['gift_id'])
  
    if order['status'] == 'completed'
      if @gift.coinbase_invoice_id == order['button']['id']
        @gift.update_attributes(funded_at: Time.now)   
      end 
    end 
  end 
end 