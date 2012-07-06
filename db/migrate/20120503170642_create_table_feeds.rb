class CreateTableFeeds < ActiveRecord::Migration
  def up
    create_table :feeds do |t|
      t.string :link
      t.integer :interest_id
          
      t.timestamps
    end
  end

  def down
   drop_table :feeds
  end
end
