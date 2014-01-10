require 'httparty'

module Ripple
  module Gateway
    class Client
      include HTTParty
      def initialize(opts)
        @api = opts[:gateway_api_url] || 'localhost:4000'
      end
    
      def get_gateway_account(user_id)
        self.class.get("#{@api}/v1/gateway/users/#{user_id}/gateway_account").
          parsed_response
      end
    end 
  end
end
