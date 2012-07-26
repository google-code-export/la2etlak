class AddColumnRankToInterests < ActiveRecord::Migration
  def up
    add_column :interests, :rank, :integer
  end

  def down
    remove_column :interests, :rank
  end
end
