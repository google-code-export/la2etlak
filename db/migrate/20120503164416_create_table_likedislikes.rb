class CreateTableLikedislikes < ActiveRecord::Migration
  def up
    create_table :likedislikes do |t|
      t.integer :user_id
      t.integer :story_id
      t.integer :action
          
      t.timestamps
    end
  end

  def down
   drop_table :likedislikes
  end
end
