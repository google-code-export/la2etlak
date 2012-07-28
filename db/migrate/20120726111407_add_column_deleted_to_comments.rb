class AddColumnDeletedToComments < ActiveRecord::Migration
  def up
    add_column :comments, :deleted, :boolean
  end

  def down
    remove_column :comments, :deleted
  end
end
