class Api::PaymentsController < ApplicationController
  protect_from_forgery :except => [:notification]
  before_filter :verify_completed
  def notification
    custom = JSON.parse(params['order']['custom'])
    if custom['invoice_id']
      handle_ripple_payment(custom)
    elsif (gift = Gift.find(custom['gift_id'].to_i))
      gift.update_attributes(funded_at: Time.now)  
    end
    render status: 200
  end

  def verify_completed
    params['order']['status'] == 'completed'
  end

  def handle_ripple_payment(custom)
    invoice = RippleBridgeInvoice.find(custom['invoice_id'])
    if invoice.secret == custom['secret']
      Resque.enqueue(Ripple::PaymentWorker, {
        destination: invoice.bitcoin_address,
        currency: 'BTC',
        amount: invoice.amount
      })  
      invoice.funded = true
      invoice.ripple_tx_status = 'queued'
      invoice.save
    end
  end
end
