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

  def create
    @escrow = Escrow.create(
      auth_provider: params.require(:auth_provider),
      auth_uid: params.require(:auth_uid),
      amount: params.require(:amount),
      currency: params.require(:currency)
    )
    render json: { invoice_url: "https://coinbase.com/checkouts/#{@escrow.invoice_id}" }
  end
end
