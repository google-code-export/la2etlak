class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :story
      t.string :content
      t.timestamps
    end
    add_index :comments, ['user_id','story_id']
  end
end
