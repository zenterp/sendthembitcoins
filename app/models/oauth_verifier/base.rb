require 'oauth2'

module OauthVerifier
  class Base
    def initialize opts
      @consumer_key = opts[:consumer_key]
      @consumer_secret = opts[:consumer_secret]
    end

    def client
      @client ||= OAuth2::Client.new(@consumer_key, @consumer_secret)
    end

    def validate(user_access_token)
      case user_access_token
      when String
        @access_token = OAuth2::AccessToken.new(client, user_access_token)
      when Hash
        @access_token = OAuth2::AccessToken.from_hash(client, user_access_token)
      end
    end
  end
end
