class Gift < ActiveRecord::Base
  attr_accessible :bitcoin_amount, 
    :coinbase_invoice_id, 
    :funded_at, 
    :recipient_bitcoin_address, 
    :recipient_twitter_username, 
    :retrieved_at, 
    :revoked_at, 
    :network, 
    :recipient_uid

  validates_presence_of :recipient_twitter_username,
    :bitcoin_amount,
    :coinbase_invoice_id

  validates :bitcoin_amount, numericality: { 
    greater_than_or_equal_to: 0.01 
  }

  scope :for_twitter_user, ->(twitter_username) { 
    where(recipient_twitter_username: twitter_username) 
  }  
  scope :claimed, where("retrieved_at IS NOT NULL")
  scope :unclaimed, where("retrieved_at IS NULL")
  scope :funded, where("funded_at IS NOT NULL")
  scope :unfunded, where("funded_at IS NULL")
end
