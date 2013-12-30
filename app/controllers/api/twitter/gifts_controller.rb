class Api::Twitter::GiftsController < ApplicationController

  # POST /api/twitter/gifts
  def create
    user_id = params.require(:user_id).downcase
    bitcoin_amount = params.require(:bitcoin_amount)
    render json: Gift.create_twitter(user_id, bitcoin_amount)
  end

  # POST /api/twitter/gifts/:id/claim
  def claim
    gift = Gift.find(params.require([:gift_id]))
    claimable_gifts = Gift.for_twitter_user(current_user[:twitter_username].downcase).unclaimed

    if claimable_gifts.collect(&:id).include?(gift.id)
      gift.claim!(params.require([:receive_address]))
      render json: gift
    else
      render json: { }
    end
  end 

  # POST /api/twitter/gifts/claim
  def claim_all
    bitcoin_address = params.require(:receive_address)
    gifts = Gift.for_twitter_user(current_user[:twitter_username]).unclaimed
    Gift.claim_all(gifts, bitcoin_address)
    render json: { gifts: gifts }
  end

  # GET /api/twitter/gifts
  def claimable
    access_token = params.require(:access_token)
    user_id = params.require(:user_id)

    if (twitter_username = session[:twitter].try(:[], 'name'))
      gifts = Gift.funded.unclaimed.for_twitter_user(twitter_username)
      render json: { 
        gifts: { 
          claimable: {
            count: gifts.count,
            total: gifts.sum(&:bitcoin_amount).round(3)
          },
          all: {
            gifts: gifts
          }
        }
      }
    else
      render json: []
    end
  end
end
