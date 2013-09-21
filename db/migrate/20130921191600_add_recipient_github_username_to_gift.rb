class AddRecipientGithubUsernameToGift < ActiveRecord::Migration
  def change
    add_column :gifts, :recipient_github_username, :string
  end
end
