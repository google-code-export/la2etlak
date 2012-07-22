<<<<<<< HEAD
class Share
    include Mongoid::Document
    include Mongoid::Timestamps
=======
class Share 
  include Mongoid::Document
  include Mongoid::Timestamps
 
>>>>>>> df966192cdaa5c71992d6b5d5be1160e562c610f
  attr_accessible :story_id, :user_id
 
  field :user_id, type: Integer
  field :story_id, type: => Integer
 
  belongs_to :shared_story, class_name: "Story"#, foreign_key: "story_id"
  belongs_to :sharer, class_name: "User"#, foreign_key: "user_id"
 
  validates :story_id, presence: true
  validates :user_id, presence: true
end
