class AddNewPasswordToUsers < ActiveRecord::Migration
  def up
    add_column :users, :new_password, :string
  end

  def down
    remove_column :users, :new_password
  end
end
