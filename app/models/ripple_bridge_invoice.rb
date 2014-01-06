class RippleBridgeInvoice < ActiveRecord::Base
  attr_accessible :amount, :ripple_address, :coinbase_invoice_id, :currency, :funded, :ripple_tx_hash, :ripple_tx_status, :secret

  validates_presence_of :amount, :ripple_address, :currency, :secret
end
