class RemoveRevokedAtFromGifts < ActiveRecord::Migration
  def up
    remove_column :gifts, :revoked_at
  end

  def down
    add_column :gifts, :revoked_at, :datetime
  end
end
