class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.integer :owner
      t.integer :user
      t.integer :story
      t.integer :comment
      t.integer :notify_type
      t.boolean :new

      t.timestamps
    end
  end
end
