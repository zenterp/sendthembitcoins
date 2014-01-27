class Escrow < ActiveRecord::Base
  attr_accessible :accepted_at, :amount, :auth_provider, :auth_uid, :currency, :funded_at, :invoice_id, :invoice_provider
  validates_presence_of :currency, :amount, :auth_uid, :auth_provider
  after_create :set_invoice

  def set_invoice
    update_attributes({
      invoice_id: generate_invoice['button']['code'],
      invoice_provider: 'coinbase'
    })
  end

  def accept(receive_address)
    if funded_at && !accepted_at && (currency.downcase == 'btc')
      result = bitcoin_client.send_money(receive_address, amount)
      if result && result.success?
        update_attributes({
          accepted_at: Time.now
        })
      end
    end
  end

private

  def generate_invoice
    bitcoin_client.create_button(
      "an escrow of bitcoin",
      amount.to_f * 1.01,
      "claimable by #{auth_uid} on #{auth_provider}",
      { escrow_id: id }.to_json,
      { variable_price: false }
    )
  end

  def bitcoin_client(client=nil)
    client ||= Coinbase::Client.new(ENV['COINBASE_API_KEY'])
  end 
end

