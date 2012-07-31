class RemoveTypeFromInterests < ActiveRecord::Migration
  def up
    remove_column :interests, :type
      end

  def down
    add_column :interests, :type, :string
  end
end
