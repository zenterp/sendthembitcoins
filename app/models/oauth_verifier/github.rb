require 'json'

module OauthVerifier
  class Github
    def validate username, user_access_token
      user = ::Github::Users.new oauth_token: user_access_token

      begin
        user.get.body['login'] == username
      rescue
        false
      end
    end
  end
end
