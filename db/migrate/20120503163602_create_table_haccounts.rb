class CreateTableHaccounts < ActiveRecord::Migration
  def up
    create_table :haccounts do |t|
      t.integer :user_id
      t.string :email
      t.string :password
          
      t.timestamps
    end
  end

  def down
   drop_table :haccounts
  end
end
