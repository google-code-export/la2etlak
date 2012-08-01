class AddEndTagToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :end_tag, :string
  end
end
