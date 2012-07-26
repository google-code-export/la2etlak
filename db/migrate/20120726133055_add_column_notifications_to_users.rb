class AddColumnNotificationsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :notifications, :integer
  end

  def down
    remove_column :users, :notifications
  end
end
