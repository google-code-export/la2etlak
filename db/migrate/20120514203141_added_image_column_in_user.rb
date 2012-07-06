class AddedImageColumnInUser < ActiveRecord::Migration
  def up
    add_column :users, :image, :string
  end

  def down
    remove_column :users, :image
  end
end
