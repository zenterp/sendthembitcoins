class Escrow < ActiveRecord::Base
  attr_accessible :accepted_at, :amount, :auth_provider, :auth_uid, :currency, :funded_at
  validates_presence_of :currency, :amount, :auth_uid, :auth_provider
end