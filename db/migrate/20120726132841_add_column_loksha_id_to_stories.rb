class AddColumnLokshaIdToStories < ActiveRecord::Migration
  def up
    add_column :stories, :loksha_id, :string
  end

  def down
    remove_column :stories, :loksha_id
  end
end
