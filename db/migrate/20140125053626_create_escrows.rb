class CreateEscrows < ActiveRecord::Migration
  def change
    create_table :escrows do |t|
      t.string :auth_provider, null: false
      t.string :auth_uid, null: false
      t.decimal :amount, null: false
      t.string :currency, null: false
      t.datetime :funded_at
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
