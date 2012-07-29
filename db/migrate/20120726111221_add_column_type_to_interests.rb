class AddColumnTypeToInterests < ActiveRecord::Migration
  def up
    add_column :interests, :type, :string
  end

  def down
    remove_column :interests, :type
  end
end
