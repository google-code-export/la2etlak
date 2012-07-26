class AddColumnBirthDateToUsers < ActiveRecord::Migration
  def up
    add_column :users, :birth_date, :date
  end

  def down
    remove_column :users, :birth_date
  end
end
