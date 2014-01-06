module Ripple
  class Payment
    def initialize(opts)
      @destination = opts[:destination]
      @currency = opts[:currency]
      @amount = opts[:amount]
    end

    def submit_with(ripple_client)
      unless ripple_client.class == Ripple::Abstract
        raise TypeError, 'Must submit with a Ripple::Abstract'
      end

      @client = ripple_client
      transaction_hash = nil 
      while !transaction_hash
        begin 
          transaction_hash = send
        rescue => e
          puts e
          sleep 0.3
        end 
      end
      transaction_hash
    end

    def send
      @client.send_basic_transaction(
        destination: @destination, 
        currency: @currency, 
        amount: @amount
      )
    end
  end
end
