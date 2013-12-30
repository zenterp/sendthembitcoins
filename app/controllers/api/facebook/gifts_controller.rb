class Api::Facebook::GiftsController < ApplicationController
  before_filter :validate_facebook_user, except: :create

  # POST /api/gifts/facebook
  def create
    user_id = params.require(:user_id)
    bitcoin_amount = params.require(:bitcoin_amount)
    gift = Gift.create({
      auth_provider: 'facebook',
      user_id: user_id,
      bitcoin_amount: bitcoin_amount
    })

    render json: gift.to_json
  end

  # GET /api/facebook/gifts
  def index
    render json: Gift.for_user(@user_id, 'facebook')
  end

  # POST /api/gifts/facebook/:id/claim
  def claim
    bitcoin_address = params.require(:bitcoin_address)
    gift = Gift.find(params[:id])
    if gift
      if gift.user_id == @user_id
        gift.claim!
        render json: gift
      else
        render status: 401
      end
    else 
      render status: 400
    end
  end

  # POST /api/gifts/facebook/claim
  def claim_all
    bitcoin_address = params.require(:bitcoin_address)
    render text: 'claim all the gifts'
  end

  def validate_facebook_user
    @user_id = params.require(:user_id)
    @access_token = params.require(:access_token)
    valid = OauthVerifier::Facebook::validate(@user_id, @access_token)
    render status: 401 unless valid
  end
end
