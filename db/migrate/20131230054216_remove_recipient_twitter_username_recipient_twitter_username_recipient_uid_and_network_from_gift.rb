class RemoveRecipientTwitterUsernameRecipientTwitterUsernameRecipientUidAndNetworkFromGift < ActiveRecord::Migration
  def up
    remove_column :gifts, :recipient_twitter_username
    remove_column :gifts, :recipient_github_username
    remove_column :gifts, :recipient_uid
    remove_column :gifts, :network
  end

  def down
    add_column :gifts, :recipient_twitter_username, :string
    add_column :gifts, :recipient_github_username, :string
    add_column :gifts, :recipient_uid, :string
    add_column :gifts, :network, :string
  end
end
