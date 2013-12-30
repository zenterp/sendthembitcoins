class Api::Twitter::GiftsController < ApplicationController
  before_filter :verify_twitter_user, except: :create

  # POST /api/twitter/gifts
  def create
    user_id = params.require(:user_id).downcase
    bitcoin_amount = params.require(:bitcoin_amount)
    render json: Gift.create({
      auth_provider: 'twitter'
      user_id: user_id, 
      bitcoin_amount: bitcoin_amount
    }).to_json
  end

  # GET /api/twitter/gifts
  def index
    render json: Gift.for_user(@user_id, 'twitter')
  end

  # POST /api/twitter/gifts/:id/claim
  def claim
    bitcoin_address = params[:bitcoin_address]
    gift_id = params[:id]
    gift = Gift.find(gift_id)
    claimable_gifts = Gift.for_user(@user_id.downcase).unclaimed

    if claimable_gifts.collect(&:id).include?(gift.id)
      gift.claim!(params.require([:bitcoin_address]))
      render json: gift
    else
      render json: { }
    end
  end 

  def claim_all
    bitcoin_address = params.require(:bitcoin_address)
    gifts = Gift.for_twitter_user(@user_id).unclaimed
    Gift.claim_all(gifts, bitcoin_address)
    render json: { gifts: gifts }
  end

  def verify_twitter_user
    @user_id = params.require(:user_id)
    @access_token = params.require(:access_token)
    @secret = params.require(:secret)
    valid = twitter_user_verifier.validate(@user_id, @access_token, @secret)
    render status: 401 unless valid
  end

private

  def twitter_user_verifier
    @twitter_user_verifier ||= OauthVerifier::Twitter.new({
      consumer_key: ENV['TWITTER_KEY_SENDTHEMBITCOINS'],
      consumer_secret: ENV['TWITTER_SECRET_SENDTHEMBITCOINS']
    })
  end
end
