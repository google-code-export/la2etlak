class CreateTableBlockStories < ActiveRecord::Migration
  def up
    create_table :block_stories do |t|
      t.integer :user_id
      t.integer :story_id
          
      t.timestamps
    end
  end

  def down
   drop_table :block_stories
  end
end
