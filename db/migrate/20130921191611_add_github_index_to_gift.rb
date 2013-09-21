class AddGithubIndexToGift < ActiveRecord::Migration
  def change
    add_index :gifts, :recipient_github_username
  end
end
