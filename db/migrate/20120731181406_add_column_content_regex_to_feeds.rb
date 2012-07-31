class AddColumnContentRegexToFeeds < ActiveRecord::Migration
  def up
    add_column :feeds, :content_regex, :string
  end

  def down
    remove_column :feeds, :content_regex
  end
end
