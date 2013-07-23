class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :coinbase_invoice_id
      t.string :recipient_bitcoin_address
      t.float :bitcoin_amount
      t.string :recipient_twitter_username
      t.datetime :funded_at
      t.datetime :retrieved_at
      t.datetime :revoked_at

      t.timestamps
    end
  end
end
