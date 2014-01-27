class Api::EscrowsController < ApplicationController
  def show
    @escrow = Escrow.find(params[:id])
    render json: @escrow
  end

  def index
    @escrows = Escrow.where(
      auth_provider: params.require(:auth_provider), 
      auth_uid: params.require(:auth_uid)
    )
    render json: @escrows
  end

  def accept
    access_token = params.require(:access_token)
    bitcoin_address = params.require(:bitcoin_address)
    @escrow = Escrow.find(params[:id])

    case @escrow.auth_provider
    when 'twitter' 
      accept_twitter
    when 'linkedin'
      accept_linkedin
    when 'facebook'
      accept_facebook
    when 'github'
      accept_github
    end
  end

  def create
    @escrow = Escrow.create(
      auth_provider: params.require(:auth_provider),
      auth_uid: params.require(:auth_uid),
      amount: params.require(:amount),
      currency: params.require(:currency)
    )
    render json: { invoice_url: "https://coinbase.com/checkouts/#{@escrow.invoice_id}" }
  end

private

  def accept_twitter
    access_token_secret = params.require(:access_token_secret)
    verifier = OauthVerifier::Twitter.new(
      consumer_key: ENV['TWITTER_KEY_SENDTHEMBITCOINS'],
      consumer_secret: ENV['TWITTER_SECRET_SENDTHEMBITCOINS']
    )
    if verifier.validate(@escrow.auth_uid, access_token, access_token_secret)
      @escrow.accept
    end
    render json: @escrow
  end
  
  def accept_github
    render json: @escrow
  end
  
  def accept_facebook
    render json: @escrow
  end
  
  def accept_linkedin
    access_token_secret = params.require(:access_token_secret)
    render json: @escrow
  end
end
