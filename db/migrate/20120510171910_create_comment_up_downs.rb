class CreateCommentUpDowns < ActiveRecord::Migration
  def change
    create_table :comment_up_downs do |t|
      t.integer :action
      t.references :user
      t.references :comment
      t.timestamps
    end
    add_index :comment_up_downs , ['user_id','comment_id']
  end
end
