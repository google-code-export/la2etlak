class CreateTableDowneds < ActiveRecord::Migration
  def up
    create_table :downeds do |t|
      t.integer :user_id
      t.integer :comment_id
          
      t.timestamps
    end
  end

  def down
   drop_table :downeds
  end
end
