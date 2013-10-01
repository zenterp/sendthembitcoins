class Api::GiftsController < ApplicationController

  # POST /api/gifts/twitter
  def create
    gift = Gift.create_twitter(params[:recipient_twitter_username], params[:bitcoin_amount])
    render json: { invoiceUrl: "https://coinbase.com/checkouts/#{gift.coinbase_invoice_id}" }
  end

  # POST /api/gifts/:id/claim
  def claim
    gift = Gift.find(params.require([:gift_id]))
    claimable_gifts = Gift.for_twitter_user(current_user[:twitter_username]).unclaimed

    if claimable_gifts.collect(&:id).include?(gift.id)
      gift.claim!(params.require([:receive_address]))
      render json: gift
    else
      render json: { }
    end
  end 

  # POST /api/gifts/claim
  def claim_all
    gifts = Gift.for_twitter_user(current_user[:twitter_username]).unclaimed
    Gift.claim_all(gifts, params.require([:receive_address]))

    render json: { gifts: gifts }
  end

  # GET /api/gifts/claimable
  def claimable
    if (twitter_username = session[:twitter].try(:[], :name))
      gifts = Gift.for_twitter_user(twitter_username).unclaimed
      render json: { gifts:  { claimable: gifts }}
    else
      render json: { gifts:  { claimable: [] }}
    end
  end

  private

  def coinbase_client
    @coinbase_client ||= Coinbase::Client.new(ENV['COINBASE_API_KEY'])
  end 
end
