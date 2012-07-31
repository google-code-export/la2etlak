class AddDefaultValueToRank < ActiveRecord::Migration
  def self.up
     change_column :stories, :rank, :integer, :default => 0
     change_column :users, :rank, :integer, :default => 0
     change_column :interests, :rank, :integer, :default => 0
  end
end
