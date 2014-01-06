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

  def handle_ripple_payment
    invoice = Invoice.find(invoice_id)
    if invoice.secret == custom['secret']
      Rescue.enqueue(Ripple::PaymentWorker, {
        destination: invoice.bitcoin_address,
        currency: 'BTC',
        amount: invoice.amount
      })  
    end

  end
end
