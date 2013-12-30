class Rename < ActiveRecord::Migration
  def up
    rename_column :gifts, :coinbase_invoice_id, :invoice_id
  end

  def down
    rename_column :gifts, :invoice_id, :coinbase_invoice_id
  end
end
