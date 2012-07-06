class CreateTableAdmins < ActiveRecord::Migration
  def up
    create_table :admins do |t|
    
    t.timestamps
    end
  end

  def down
   drop_table :admins
  end
end
