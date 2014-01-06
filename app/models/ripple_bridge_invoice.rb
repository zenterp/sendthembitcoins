class RippleBridgeInvoice < ActiveRecord::Base
  attr_accessible :amount, :ripple_address, :coinbase_invoice_id, :currency, :funded, :ripple_tx_hash, :ripple_tx_status, :secret

  validates_presence_of :amount, :ripple_address, :currency, :secret, :coinbase_invoice_id

  before_create :set_random_secret

  def set_random_secret
    self.secret = SecureRandom.hex
  end
end
