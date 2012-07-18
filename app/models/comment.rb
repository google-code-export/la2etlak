class Comment
  
=begin  
  This class is done solely by me, Menisy
=end

include Mongoid::Document
include Mongoid::Timestamps

field :user_id, type: Integer 
field :story_id, type: Integer 
field :content, type: String 

	index({ user_id: 1 , story_id: 1 }, { name: "index_comments_on_user_id_and_story_id" })

  attr_accessible :content
  belongs_to :user
  belongs_to :story
  has_many :comment_up_downs
  validates_presence_of :content
  validates_presence_of :user
  validates_presence_of :story
end
