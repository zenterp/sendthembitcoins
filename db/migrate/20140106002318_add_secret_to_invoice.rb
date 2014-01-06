class AddSecretToInvoice < ActiveRecord::Migration
  def change
    add_column :ripple_bridge_invoices, :secret, :string
  end
end
