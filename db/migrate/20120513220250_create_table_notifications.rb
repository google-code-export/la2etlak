class CreateTableNotifications < ActiveRecord::Migration
  def up
  	create_table :notifications do |t|
  		t.integer :user_id
  		t.integer :type
  		t.string :message
  		t.string :url
  	end 
  	add_index :notifications, [:user_id], :unique => true
  end

  def down
  	drop_table :notifications
  end
end
