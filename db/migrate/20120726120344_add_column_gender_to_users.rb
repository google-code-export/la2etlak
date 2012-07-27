class AddColumnGenderToUsers < ActiveRecord::Migration
  def up
    add_column :users, :gender, :string
  end

  def down
    remove_column :users, :gender
  end
end
