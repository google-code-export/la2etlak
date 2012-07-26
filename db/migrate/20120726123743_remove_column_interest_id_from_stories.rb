class RemoveColumnInterestIdFromStories < ActiveRecord::Migration
  def up
  	remove_column :stories, :interest_id
  end

  def down
  	add_column :stories, :interest_id, :integer
  end
end
