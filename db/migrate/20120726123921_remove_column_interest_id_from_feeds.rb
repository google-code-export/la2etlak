class RemoveColumnInterestIdFromFeeds < ActiveRecord::Migration
  def up
  	remove_column :feeds, :interest_id
  end

  def down
  	add_column :feeds, :interest_id, :integer
  end
end
