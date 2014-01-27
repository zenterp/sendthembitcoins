require 'json'
require 'twitter_oauth'

module OauthVerifier
  class Twitter < Base
    def validate user_id, token, secret
      client = TwitterOAuth::Client.new({
        consumer_key: @consumer_key,
        consumer_secret: @consumer_secret,
        token: token,
        secret: secret
      })
      
      begin
        client.verify_credentials['screen_name'] == user_id
      rescue
        false
      end
    end
  end
end
