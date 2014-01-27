require 'json'

module OauthVerifier
  class Linkedin
    def validate user_id, user_access_token, access_token_secret
      client = LinkedIn::Client.new(ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'])

      begin
        client.authorize_from_access(user_access_token, access_token_secret)
        client.profile['site_standard_profile_request']['url'].match(/id=[0-9]+/)[0].gsub('id=','')
        profile_url = client.profile['site_standard_profile_request']['url']
        profile_url.match(/id=[0-9]+/)[0].gsub('id=','').to_s == user_id.to_s
      rescue
        false
      end
    end
  end
end
