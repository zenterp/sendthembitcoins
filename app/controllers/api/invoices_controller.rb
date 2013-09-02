class Api::InvoicesController < ApplicationController
  # POST /api/invoices
  def create
    gift = Gift.create({
      recipient_twitter_username: params[:recipient_twitter_username],
      bitcoin_amount: params[:bitcoin_amount],
      coinbase_invoice_id: 'false'
    })
    
    button = coinbase_client.create_button(
      "bitcoin gift to @#{params[:recipient_twitter_username]} on twitter", 
      gift.bitcoin_amount.to_f * 1.01,
      nil, # description
      { gift_id: gift.id }.to_json, # custom information
      { variable_price: true } # options
    )

    render json: { invoiceUrl: "https://coinbase.com/checkouts/#{button['button']['code']}" }
  end

private

  def coinbase_client
    @coinbase_client ||= Coinbase::Client.new(ENV['COINBASE_API_KEY'])
  end 
end 