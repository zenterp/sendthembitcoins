class Api::Ripple::BridgeInvoicesController < ApplicationController
  def create
    @ripple_address = params.require(:ripple_address)
    @amount = params.require(:amount)

    invoice = RippleBridgeInvoice.create(
      amount: @amount.to_f,
      ripple_address: @ripple_address,
      currency: 'BTC'
    )

    invoice.coinbase_invoice_id = Coinbase::Invoice.create(
      amount: invoice.amount, 
      invoice_id: invoice.id, 
      invoice_secret: invoice.secret
    )

    invoice.save

    render json: { invoice_url: "https://coinbase.com/checkouts/#{invoice.coinbase_invoice_id}" }
  end
end
