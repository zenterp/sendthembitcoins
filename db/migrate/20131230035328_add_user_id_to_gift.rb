class AddUserIdToGift < ActiveRecord::Migration
  def change
    add_column :gifts, :user_id, :string
  end
end
