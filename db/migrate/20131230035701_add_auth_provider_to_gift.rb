class AddAuthProviderToGift < ActiveRecord::Migration
  def change
    add_column :gifts, :auth_provider, :string
  end
end
