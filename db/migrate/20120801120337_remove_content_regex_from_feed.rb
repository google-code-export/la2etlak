class RemoveContentRegexFromFeed < ActiveRecord::Migration
  def up
    remove_column :feeds, :content_regex
      end

  def down
    add_column :feeds, :content_regex, :string
  end
end
