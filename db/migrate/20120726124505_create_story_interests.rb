class CreateStoryInterests < ActiveRecord::Migration
  def change
    create_table :story_interests do |t|
      t.integer :interest_id
      t.integer :story_id

      t.timestamps
    end
  end
end
