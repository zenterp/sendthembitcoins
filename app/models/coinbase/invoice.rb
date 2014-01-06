module Coinbase
  class Invoice
    def create(opts)
      checkout = bitcoin_client.create_button(
       "Note: Ensure a trust line of #{opts[:amount]} BTC to #{ENV['RIPPLE_ACCOUNT']} before sending.",
        opts[:amount],
        "Sending bitcoins into the ripple network", 
        { id: opts[:invoice_id], secret: opts[:invoice_secret] }.to_json,
        { variable_price: true }
      )
      checkout['button']['code']
    end

    def bitcoin_client(client=nil)
      client ||= Coinbase::Client.new(ENV['COINBASE_API_KEY'])
    end 
  end
end 
