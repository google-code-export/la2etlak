class AddFirstTagToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :first_tag, :string
  end
end
