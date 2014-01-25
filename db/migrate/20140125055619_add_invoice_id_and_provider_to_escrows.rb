class AddInvoiceIdAndProviderToEscrows < ActiveRecord::Migration
  def change
    add_column :escrows, :invoice_id, :string
    add_column :escrows, :invoice_provider, :string
  end
end
