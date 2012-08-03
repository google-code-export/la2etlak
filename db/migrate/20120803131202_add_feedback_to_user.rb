class AddFeedbackToUser < ActiveRecord::Migration
  def change
    add_column :users, :feedback, :datetime
  end
end
