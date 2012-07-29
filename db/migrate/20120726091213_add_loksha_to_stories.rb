class AddLokshaToStories < ActiveRecord::Migration
  def change
    add_column :stories, :loksha_id, :int
  end
end
