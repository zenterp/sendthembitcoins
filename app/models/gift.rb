class Gift < ActiveRecord::Base
  attr_accessible :bitcoin_amount, :coinbase_invoice_id, :funded_at, :recipient_bitcoin_address, :recipient_twitter_username, :retrieved_at, :revoked_at
  validates_presence_of :recipient_twitter_username, :bitcoin_amount, :coinbase_invoice_id
  validates :bitcoin_amount, numericality: { greater_than_or_equal_to: 0.01 }
end
