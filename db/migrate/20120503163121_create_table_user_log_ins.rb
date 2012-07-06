class CreateTableUserLogIns < ActiveRecord::Migration
  def up
    create_table :user_log_ins do |t|
      t.integer :user_id
          
      t.timestamps
    end
  end

  def down
   drop_table :user_log_ins
  end
end
