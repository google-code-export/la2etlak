class Share < ActiveRecord::Base
  attr_accessible :story_id, :user_id

  belongs_to :shared_story, class_name: "Story", foreign_key: "story_id"
  belongs_to :sharer, class_name: "User", foreign_key: "user_id"
  
  validates :story_id, presence: true
  validates :user_id, presence: true

  def self.get_shares_of_story (story_id)
  	Share.find_all_by_story_id(story_id)
  end
end
