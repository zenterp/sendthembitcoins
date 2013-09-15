class Api::GiftsController < ApplicationController

  # POST /api/gifts/twitter
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

  def claim
    gift = Gift.find(params[:gift_id])

    if current_user_can_claim(gift)
      if params[:receive_address].present?
        coinbase_client.send_money(params[:receive_address], gift.bitcoin_amount)
        gift.retrieved_at = Time.now
        gift.save
        render json: gift
      else
        render json: { error: 'no receive id present' }
      end
    else
      render json: { }
    end
  end 

  def claimable
    if current_user && current_user[:twitter_username].present?
      gifts = Gift.for_twitter_user(current_user[:twitter_username]).unclaimed
      render json: gifts
    else
      render json: {}
    end
  end

  private

    def current_user_can_claim(gift)
      !current_user.empty? && 
        gift.recipient_twitter_username == current_user[:twitter_username] &&
        gift.retrieved_at.nil?
    end

    def coinbase_client
      @coinbase_client ||= Coinbase::Client.new(ENV['COINBASE_API_KEY'])
    end 
end