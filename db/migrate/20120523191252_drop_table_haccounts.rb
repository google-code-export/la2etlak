class DropTableHaccounts < ActiveRecord::Migration
  def change
  	drop_table :haccounts
  end
end
