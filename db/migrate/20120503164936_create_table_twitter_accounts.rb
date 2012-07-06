class CreateTableTwitterAccounts < ActiveRecord::Migration
  def up
    create_table :twitter_accounts do |t|
      t.integer :user_id
      t.string :auth_token
      t.string :auth_secret
          
      t.timestamps
    end
  end

  def down
   drop_table :twitter_accounts
  end
end
