class AddIndexToCoinbaseOauth < ActiveRecord::Migration
  def change
    add_index :coinbase_oauthorizations, :uid
  end
end
