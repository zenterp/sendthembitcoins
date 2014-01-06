class AddRippleAddressToRippleBridgeInvoices < ActiveRecord::Migration
  def change
    add_column :ripple_bridge_invoices, :ripple_address, :string
  end
end
