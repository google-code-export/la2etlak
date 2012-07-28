class CreateInterestFeeds < ActiveRecord::Migration
  def change
    create_table :interest_feeds do |t|
      t.integer :interest_id
      t.integer :feed_id

      t.timestamps
    end
  end
end
