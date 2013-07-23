class AddRecipientUidAndNetworkToGift < ActiveRecord::Migration
  def change
    add_column :gifts, :recipient_uid, :string
    add_column :gifts, :network, :string
  end
end
