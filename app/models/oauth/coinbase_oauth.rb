module Oauth
  class CoinbaseOauth
    def self.user_from_omniauth(omniauth_hash)
      return {
        uid: omniauth_hash['info']['id'],
        username: omniauth_hash['info']['name'],
        email: omniauth_hash['info']['email']
      }
    end

    def self.get_receive_address(access_token, refresh_token)
      client = OAuth2::Client.new(ENV['SENDTHEMBITCOINS_COINBASE_KEY'], ENV['SENDTHEMBITCOINS_COINBASE_SECRET'])
      token  = OAuth2::AccessToken.new(client, access_token, refresh_token: refresh_token)
      address = JSON.parse(token.get('https://coinbase.com/api/v1/account/receive_address').body)['address']
      return address
    end
  end
end
