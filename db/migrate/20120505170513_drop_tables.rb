class DropTables < ActiveRecord::Migration
  def change
    drop_table :comments
    drop_table :uppeds
    drop_table :downeds
  end

end
