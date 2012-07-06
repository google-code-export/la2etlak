class BlockStory < ActiveRecord::Base
  attr_accessible :user_id, :story_id
  
  belongs_to :blocked_story, class_name: "Story", foreign_key: "story_id"
  belongs_to :blocker, class_name: "User", foreign_key: "user_id"
  
  validates :story_id, presence: true
  validates :user_id, presence: true
end
