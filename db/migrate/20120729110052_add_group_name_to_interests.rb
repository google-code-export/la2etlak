class AddGroupNameToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :group_name, :string
  end
end
