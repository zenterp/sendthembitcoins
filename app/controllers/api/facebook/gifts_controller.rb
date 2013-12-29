class Api::Facebook::GiftsController < ApplicationController
  before_filter :validate_facebook_user, except: :create

  # POST /api/gifts/facebook
  def create
    user_id = params.require(:user_id)
    bitcoin_amount = params.require(:bitcoin_amount)
    # also validate that user is real facebook user
    # validate the amount is > some small amount

    render text: 'Facebook::Gift.create(user_id, bitcoin_amount)'
  end

  # GET /api/facebook/gifts
  def index
    render text: 'Facebook::Gift.for_user(user_id)'
  end

  # GET /api/facebook/gifts/:id
  def show
    render text: 'Facebook::Gift.find(params[:id])'
  end

  # POST /api/gifts/facebook/:id/claim
  def claim
    bitcoin_address = params.require(:bitcoin_address)
    render text: 'Facebook::Gift.find(params[:id]).claim!(bitcoin_address)'
  end

  # POST /api/gifts/facebook/claim
  def claim_all
    bitcoin_address = params.require(:bitcoin_address)
    render text: 'claim all the gifts'
  end

  def validate_facebook_user
    @user_id = params.require(:user_id)
    @access_token = params.require(:access_token)
    valid = OAuthValidator::Facebook::validate(@user_id, @access_token)
    render status: 401 unless valid
  end
end
