class CoinbaseOauthorization < ActiveRecord::Base
  attr_accessible :bitcoin_address, :email, :expires, :expires_at, :name, :refresh_token, :token, :uid
  validates_presence_of :uid
  validates_uniqueness_of :uid

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
end
