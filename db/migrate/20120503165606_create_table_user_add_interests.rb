class CreateTableUserAddInterests < ActiveRecord::Migration
  def up
    create_table :user_add_interests  do |t|
      t.integer :user_id
      t.integer :interest_id
          
      t.timestamps
    end
  end

  def down
   drop_table :user_add_interests
  end
end
