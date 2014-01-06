class RippleBridgeInvoice < ActiveRecord::Base
  attr_accessible :amount, :coinbase_invoice_id, :currency, :funded, :ripple_tx_hash, :ripple_tx_status
end
