class CreateFlickrAccounts < ActiveRecord::Migration
  def change
    create_table :flickr_accounts do |t|
      t.integer :user_id
      t.string :consumer_key
      t.string :secret_key

      t.timestamps
    end
  end
end
