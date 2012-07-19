class Likedislike 

  include Mongoid::Document
  include Mongoid::Timestamps
  attr_accessible :action, :story_id, :user_id
  field :user_id, type:  Integer
  field :story_id, type:  Integer
  field :action, type:  Integer
  belongs_to :likedisliked_story, class_name: "Story"#, foreign_key: "story_id"
  belongs_to :likedisliker, class_name: "User" #, foreign_key: "user_id"
  
  validates :story_id, presence: true
  validates :user_id, presence: true
end
