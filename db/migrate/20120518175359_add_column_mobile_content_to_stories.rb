class AddColumnMobileContentToStories < ActiveRecord::Migration
  def up
    add_column :stories, :mobile_content, :text
  end

  def down
    remove_column :stories, :mobile_content
  end
end
