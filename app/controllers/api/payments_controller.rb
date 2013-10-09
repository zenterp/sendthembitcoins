class Api::PaymentsController < ApplicationController
  def notification
    if params['order']['status'] == 'completed'
      invoice_id = params['order']['button']['id']
      gift = Gift.where(coinbase_invoice_id: invoice_id).first
      gift.update_attributes(funded_at: Time.now)
      render status: 200
    end
  end
end