class CreateCoinbaseOauthorizations < ActiveRecord::Migration
  def change
    create_table :coinbase_oauthorizations do |t|
      t.string :uid
      t.string :name
      t.string :email
      t.string :token
      t.string :refresh_token
      t.integer :expires_at
      t.boolean :expires
      t.string :bitcoin_address
      t.timestamps
    end
  end
end
