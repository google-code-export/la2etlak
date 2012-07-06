class CreateTableFlags < ActiveRecord::Migration
  def up
    create_table :flags do |t|
      t.integer :user_id
      t.integer :story_id
          
      t.timestamps
    end
  end

  def down
   drop_table :flags
  end
end
