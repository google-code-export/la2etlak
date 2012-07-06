class RemoveImageFromInterestTable < ActiveRecord::Migration
  def up
  	remove_column :interests, :image
  end

  def down
  	add_column :interests, :image, :string
  end
end
