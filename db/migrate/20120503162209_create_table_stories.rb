class CreateTableStories < ActiveRecord::Migration
  def up
    create_table :stories do |t|
      t.integer :interest_id
      t.string :title
      t.text :content
      t.date :date
      t.integer :rank
      t.string :media_link
      t.string :category
      t.boolean :hidden
      t.boolean :deleted
          
      t.timestamps
    end
  end

  def down
   drop_table :stories
  end
end
