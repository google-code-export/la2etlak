class CreateTableBlockInterests < ActiveRecord::Migration
  def up
    create_table :block_interests do |t|
      t.integer :user_id
      t.integer :interest_id
          
      t.timestamps
    end
  end

  def down
   drop_table :block_interests
  end
end
