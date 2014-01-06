module Ripple::PaymentWorker
  def self.queue
    :ripple_disbursements
  end

  def perform(opts)
    @invoice  = Invoice.find(opts.delete(:invoice_id))
    payment = Ripple::Payment.new(opts)
    ripple_client = Ripple.client({
      endpoint: ENV['RIPPLED_URL'],
      client_account: ENV['RIPPLE_ACCOUNT'],
      client_secret: ENV['RIPPLE_SECRET']
    })

    transaction_hash = payment.submit_with(ripple_client)
    @invoice.ripple_tx_hash = transaction_hash
    @invoice.ripple_tx_status = 'success'
    @invoice.save
  end
end
