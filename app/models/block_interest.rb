class BlockInterest < ActiveRecord::Base
  attr_accessible :user_id, :interest_id
  
  belongs_to :blocked_interest, class_name: "Interest", foreign_key: "interest_id"
  belongs_to :blocker, class_name: "User", foreign_key: "user_id"
  
  validates :interest_id, presence: true
  validates :user_id, presence: true
end
