class Gift < ActiveRecord::Base
  after_create :generate_invoice

  attr_accessible :bitcoin_amount, 
    :coinbase_invoice_id, 
    :funded_at, 
    :recipient_bitcoin_address, 
    :recipient_twitter_username, 
    :recipient_github_username,
    :retrieved_at, 
    :revoked_at, 
    :network,
    :recipient_uid

  validates_presence_of :bitcoin_amount,
    :coinbase_invoice_id,

  validates :bitcoin_amount, numericality: { 
    greater_than_or_equal_to: 0.01 
  }

  scope :for_twitter_user, ->(twitter_username) { 
    where(recipient_twitter_username: twitter_username) 
  }

  scope :for_github_user, ->(github_username) {
    where(recipient_github_username: github_username)
  }

  scope :for_facebook_user, ->(fb_uid) {
    where(recipient_uid: fb_uid, network: 'facebook')
  }

  scope :for_linkedin_user, ->(linkedin_uid) {
    where(recipient_uid: linkedin_uid, network: 'linkedin')
  }

  scope :claimed, where("retrieved_at IS NOT NULL")
  scope :unclaimed, where("retrieved_at IS NULL")
  scope :funded, where("funded_at IS NOT NULL")
  scope :unfunded, where("funded_at IS NULL")

  def claim!(receive_address)
    coinbase_client = Coinbase::Client.new(ENV['COINBASE_API_KEY'])
    coinbase_client.send_money(receive_address, bitcoin_amount)
    update_attributes!({
      recipient_bitcoin_address: receive_address,
      retrieved_at: Time.now
    })
  end

  def generate_invoice
    update_attributes({
      coinbase_invoice_id: create_button['button']['code']
    })
  end

  class << self
    def create_twitter(username, amount)
      create({
        recipient_twitter_username: username,
        bitcoin_amount: amount,
        coinbase_invoice_id: 'false',
        network: 'twitter'
      })
    end

    def create_linkedin(username, amount)
      create({
        recipient_linkedin_username: username,
        bitcoin_amount: amount,
        coinbase_invoice_id: 'false',
        network: 'linkedin'
      })
    end

    def claim_all(gifts, receive_address)
      gifts.each do |gift|
        gift.claim!(receive_address)
      end
    end
  end

private 

  def create_button
    button = coinbase_client.create_button(
      "a bitcoin gift to you via #{network}",
      bitcoin_amount.to_f * 1.01,
      nil, # description
      { gift_id: id }.to_json, # custom information
      { variable_price: true } # options
    )
  end

  def coinbase_client
    @coinbase_client ||= Coinbase::Client.new(ENV['COINBASE_API_KEY'])
  end 
end
