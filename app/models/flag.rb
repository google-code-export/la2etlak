class Flag

<<<<<<< HEAD
    include Mongoid::Document
    include Mongoid::Timestamps
=======
  include Mongoid::Document
  include Mongoid::Timestamps
>>>>>>> df966192cdaa5c71992d6b5d5be1160e562c610f

  attr_accessible :story_id, :user_id

  field :user_id, type: Integer
  field :story_id, type: Integer

  belongs_to :flaged_story, class_name: "Story"#, foreign_key: "story_id"
  belongs_to :flager, class_name: "User"#, foreign_key: "user_id"
end
