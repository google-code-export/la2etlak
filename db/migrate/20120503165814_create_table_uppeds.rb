class CreateTableUppeds < ActiveRecord::Migration
  def up
    create_table :uppeds do |t|
      t.integer :user_id
      t.integer :comment_id
          
      t.timestamps
    end
  end

  def down
   drop_table :uppeds
  end
end
