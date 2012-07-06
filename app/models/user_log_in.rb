class UserLogIn < ActiveRecord::Base
  attr_accessible :user_id
  
  belongs_to :user, class_name: "User"
end
