class AddUsersPasswordResetFields < ActiveRecord::Migration
def self.up  
add_column :admins, :perishable_token, :string, :default => "", :null => false  
#add_column :admins, :email, :string, :default => "", :null => false  
  
add_index :admins, :perishable_token  
#add_index :admins, :email  
end  
  
def self.down  
remove_column :admins, :perishable_token  
remove_column :admins, :email  
end  
end
