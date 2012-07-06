class AddColumnFacebookIdToFacebookAccounts < ActiveRecord::Migration
  def up
    add_column :facebook_accounts, :facebook_id, :bigint
  end

  def down
    remove_column :facebook_accounts, :facebook_id
  end
end
