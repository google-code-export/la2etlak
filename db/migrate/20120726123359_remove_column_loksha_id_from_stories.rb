class RemoveColumnLokshaIdFromStories < ActiveRecord::Migration
  def up
  	remove_column :stories, :loksha_id
  end

  def down
  	add_column :stories, :loksha_id, :string
  end
end
