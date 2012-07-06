class CreateTableShares < ActiveRecord::Migration
  def up
    create_table :shares do |t|
      t.integer :user_id
      t.integer :story_id
          
      t.timestamps
    end
  end

  def down
   drop_table :shares
  end
end
