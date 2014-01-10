require 'httparty'

module Ripple
  module Gateway
    class Client
      include HTTParty
      def initialize(opts)
        @api = opts[:gateway_api_url] || 'localhost:4000'
      end

      def create_user(name, password)
        self.class.post("#{@api}/v1/gateway/users", { body: {
          name: name, password: password
        }}).parsed_response
      end
    
      def get_gateway_account(user_id)
        self.class.get("#{@api}/v1/gateway/users/#{user_id}/gateway_account").
          parsed_response
      end
    
      def create_gateway_account(user_id)
        self.class.post("#{@api}/v1/gateway/users/#{user_id}/gateway_accounts").
          parsed_response
      end
    
      def get_gateway_transactions(account_id)
        self.class.get("#{@api}/v1/gateway/accounts/#{account_id}/transactions").
          parsed_response
      end

      def create_gateway_deposit(account_id, currency, cash_amount)
        self.class.post("#{@api}/v1/gateway/accounts/#{account_id}/deposits", {
          body: { currency: currency, cashAmount: cash_amount }
        }).parsed_response
      end
    end 
  end
end
