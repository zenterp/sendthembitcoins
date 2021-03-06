class CoinbaseOauthorization < ActiveRecord::Base
  attr_accessible :bitcoin_address, :email, :expires, :expires_at, :name, :refresh_token, :token, :uid
  validates_presence_of :uid
  validates_uniqueness_of :uid

  after_create :set_bitcoin_address
  after_update ->(oauth) {
    unless oauth[:bitcoin_address]
      set_bitcoin_address
    end
  }

  def get_bitcoin_address
    self.bitcoin_address.presence || set_bitcoin_address
  end

  def set_bitcoin_address
    address = Oauth::CoinbaseOauth::get_receive_address(token, refresh_token)
    update_attributes(bitcoin_address: address)
  end

  class << self
    def find_or_init_by_uid(uid)
      auth = self.where(uid: uid).first
      if auth
        return auth
      else
        return new(uid: uid)
      end
    end
  end

  def update_auth(auth_hash)
    update_attributes({
      uid: auth_hash['info']['id'],
      name: auth_hash['info']['name'],
      email: auth_hash['info']['email'],
      token: auth_hash['credentials']['token'],
      refresh_token: auth_hash['credentials']['refresh_token'],
      expires: auth_hash['credentials']['expires'],
      expires_at: auth_hash['credentials']['expires_at']
    })
  end
end
