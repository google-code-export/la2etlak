class CreateTableComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.integer :user_id
      t.integer :story_id
      t.string :content
      t.boolean :hidden
                
      t.timestamps
    end
  end

  def down
   drop_table :comments
  end
end
