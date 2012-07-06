class Share < ActiveRecord::Base
  attr_accessible :story_id, :user_id

  belongs_to :shared_story, class_name: "Story", foreign_key: "story_id"
  belongs_to :sharer, class_name: "User", foreign_key: "user_id"
  
  validates :story_id, presence: true
  validates :user_id, presence: true
end
