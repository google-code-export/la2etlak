class RenameColumnsInTumblrAccounts < ActiveRecord::Migration
  def up
    rename_column :tumblr_accounts, :consumer_key, :email
    rename_column :tumblr_accounts, :secret_key, :password
  end

  def down
    rename_column :tumblr_accounts, :email, :consumer_key
    rename_column :tumblr_accounts, :password, :secret_key
  end
end
