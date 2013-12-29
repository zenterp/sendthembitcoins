class Api::Facebook::GiftsController < ApplicationController
  # POST /api/gifts/facebook
  def create
    user_id = params.require(:user_id)
    bitcoin_amount = params.require(:bitcoin_amount)
    render text: 'create a gift'
  end

  # GET /api/gifts/facebook
  def index
    user_id = params.require(:user_id)
    access_token = params.require(:access_token)
    render text: 'list gifts for this users'
  end

  # GET /api/gifts/facebook/:id
  def show
    user_id = params.require(:user_id)
    access_token = params.require(:access_token)
    render text: 'show the gift'
  end

  # POST /api/gifts/facebook/:id/claim 
  def claim
    user_id = params.require(:user_id)
    access_token = params.require(:access_token)
    bitcoin_address = params.require(:bitcoin_address)
    render text: 'claim the gift'
  end

  # POST /api/gifts/facebook/claim
  def claim_all
    user_id = params.require(:user_id)
    access_token = params.require(:access_token)
    bitcoin_address = params.require(:bitcoin_address)
    render text: 'claim all the gifts'
  end
end
