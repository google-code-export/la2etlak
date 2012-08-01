class AddRssFeedToStory < ActiveRecord::Migration
  def change
    add_column :stories, :rss_feed, :string
  end
end
