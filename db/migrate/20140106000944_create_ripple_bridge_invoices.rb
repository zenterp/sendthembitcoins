class CreateRippleBridgeInvoices < ActiveRecord::Migration
  def change
    create_table :ripple_bridge_invoices do |t|
      t.boolean :funded
      t.string :coinbase_invoice_id
      t.decimal :amount
      t.string :currency
      t.string :ripple_tx_status
      t.string :ripple_tx_hash

      t.timestamps
    end
  end
end
