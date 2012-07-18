class BlockStory
#Author: Akila ------------------------------------Mongo Stuff------------------------------------
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :user_id, :story_id

#Associations 
  belongs_to :blocked_story, class_name: "Story", foreign_key: "story_id"
  belongs_to :blocker, class_name: "User", foreign_key: "user_id"

#Validations  
  validates_presence_of :story_id
  validates_presence_of :user_id
#----------------------------------------end of mongo stuff-------------------------------#
end
