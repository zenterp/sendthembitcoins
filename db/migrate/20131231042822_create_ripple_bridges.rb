class CreateRippleBridges < ActiveRecord::Migration
  def change
    create_table :ripple_bridges do |t|
      t.integer :destination_tag
      t.string :bitcoin_address

      t.timestamps
    end
  end
end
