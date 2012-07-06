class UserAddInterest < ActiveRecord::Base
  attr_accessible :interest_id, :user_id
  
  belongs_to :added_interest, class_name: "Interest", :foreign_key => "interest_id"
  belongs_to :adding_user, class_name: "User", :foreign_key => "user_id"
  
  validates :interest_id, presence: true
  validates :user_id, presence: true

end
