class AddColumnsToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :first_name, :string
    add_column :admins, :last_name, :string
    add_column :admins, :email, :string
    add_column :admins, :crypted_password, :string
    add_column :admins, :password_salt, :string
    add_column :admins, :persistence_token, :string
  end
end
