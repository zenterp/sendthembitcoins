class Api::EscrowsController < ApplicationController
  def show
    @escrow = Escrow.find(params[:id])
    render json: @escrow
  end

  def index
    @escrows = Escrow.where(
      auth_provider: params.require[:auth_provider], 
      auth_uid: params.require[:auth_uid]
    )
    render json: @escrows
  end

  def create
    @escrow = Escrow.create(
      auth_provider: params.require[:auth_provider],
      auth_uid: params.require[:auth_uid],
      amount: params.require[:amount],
      currency: params.require[:currency],
      invoice_id: params[:invoice_id],
      invoice_provider: params[:invoice_provider]
    )
    render json: @escrow
  end
end
