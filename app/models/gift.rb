class Gift < ActiveRecord::Base
  after_create :generate_invoice

  validates_presence_of :bitcoin_amount,
    :user_id,
    :auth_provider

  attr_accessible :bitcoin_amount, 
    :invoice_id, 
    :user_id,
    :auth_provider,
    :funded_at, 
    :retrieved_at,
    :recipient_bitcoin_address

  scope :for_user, ->(user_id, auth_provider) {
    where(user_id: user_id, auth_provider: auth_provider)
  }

  validates :bitcoin_amount, numericality: { 
    greater_than_or_equal_to: 0.001 
  }

  scope :funded, where("funded_at IS NOT NULL")
  scope :unclaimed, where("retrieved_at IS NULL")

  def fund!
    update_attributes(funded_at: Time.now)
  end

  def claim!(receive_address,client=nil)
    if self.funded_at != nil
      result = bitcoin_client(client).send_money(receive_address, bitcoin_amount)
      if result && result.success?
        update_attributes!({
          recipient_bitcoin_address: receive_address,
          retrieved_at: Time.now
        })
      end
    end
  end

  def generate_invoice
    update_attributes({
      invoice_id: create_invoice['button']['code']
    })
  end

  def to_json
    {
      auth_provider: self.auth_provider,
      user_id: self.user_id,
      bitcoin_amount: self.bitcoin_amount,
      invoice_url: "https://coinbase.com/checkouts/#{self.invoice_id}",
      created_at: self.created_at
    }.to_json
  end

private 

  def create_invoice
    bitcoin_client.create_button(
      "a bitcoin gift to you from a friend on #{auth_provider}",
      bitcoin_amount.to_f * 1.01,
      nil, # description
      { gift_id: id }.to_json,
      { variable_price: true }
    )
  end

  def bitcoin_client(client=nil)
    client ||= Coinbase::Client.new(ENV['COINBASE_API_KEY'])
  end 
end
