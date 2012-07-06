class CreateTableTwitterRequests < ActiveRecord::Migration
  def up
    create_table :twitter_requests do |t|
      t.integer :user_id
      t.string :request_token
      t.string :request_secret
          
      t.timestamps
    end
  end

  def down
   drop_table :twitter_requests
  end
end
