class Escrow < ActiveRecord::Base
  attr_accessible :accepted_at, :amount, :auth_provider, :auth_uid, :currency, :funded_at
end
