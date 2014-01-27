require 'json'

module OauthVerifier
  class Facebook < Base
    def validate user_id, user_access_token
      super(user_access_token)
      url = "https://graph.facebook.com/debug_token?" +
            "input_token=#{user_access_token}"
      begin
        response = JSON.parse(@access_token.get(url).body)
        user_matches = (response["data"]["user_id"].to_s == user_id.to_s)
        user_matches ? response["data"]["is_valid"] : false
      rescue
        false
      end
    end
  end
end
