class AddColumnStoryLinkToStories < ActiveRecord::Migration
  def up
    add_column :stories, :story_link, :string
  end

  def down
    remove_column :stories, :story_link
  end
end
