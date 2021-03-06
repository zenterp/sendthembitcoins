Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY_SENDTHEMBITCOINS'], ENV['TWITTER_SECRET_SENDTHEMBITCOINS']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'], scope: 'r_network'
  provider :coinbase, ENV['SENDTHEMBITCOINS_COINBASE_KEY'], ENV['SENDTHEMBITCOINS_COINBASE_SECRET'],
    scope: 'addresses'
end