class SessionAuth
  PROVIDERS = [
    :facebook,
    :twitter,
    :github,
    :linkedin,
    :coinbase
  ]

  def self.oauth_access_tokens(session)
    auth = self.new(session)
    auth.to_json
  end

  def self.clear_access_tokens(session)
    PROVIDERS.each do |provider|
      session.delete(provider)
    end
  end

  def set_access_token provider, auth
    @session[provider] = auth 
  end

  def initialize(session)
    @session = session
  end

  def to_json
    auth_tokens = {}
    SessionAuth::PROVIDERS.each do |provider|
      auth = @session[provider]
      if auth.present?
        auth_tokens[provider] = auth
      end
    end
    auth_tokens.to_json
  end
end