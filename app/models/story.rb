class Story
#Author: Akila ------------------------------------Mongo Stuff------------------------------------
  include Mongoid::Document
  include Mongoid::Timestamps
  #include StoriesHelper
#definition of some attributes:-
# :rank==>hottness of a story, :interest_id==>id of the related interest,
# :type==> 1 (Article) 2 (Image) 3 (video)

#Fields:
	field :title , type: String
  field :content , type: String
  field :date , type: Date
  field :rank , type: Integer
  field :media_link , type: String
  field :category , type: String
  field :hidden , type:Boolean
  field :deleted , type: Boolean
  field :story_link , type: String
  field :mobile_content , type: String
  attr_accessible :interest_id, :title, :date, :rank, 
		  :media_link, :category, :content, :deleted, :hidden
  
#Associations 
  belongs_to :interest
  has_many   :comments  
  has_many :shares
  has_many :sharers, class_name: "User"#, :through => :shares
  has_many :likedislikes
  has_many :likedislikers, class_name: "User"#, :through => :likedislikes
  has_many :flags
  has_many :flagers, class_name: "User"#, :through => :flags
  has_many :block_stories
  has_many :blockers, class_name: "User"#, :through => :block_stories 
  
#Validations
  URL_regex = /^(?:(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(?::[0-9]{1,5})?(\/.*)?)|(?:^$)$/ix
# putting some validations on the title and interest_id that they are present
  validates_presence_of :title
  validates_presence_of :interest_id
# checking that the media_link is a valid URL according to the regex defined above.
  validates_presence_of :media_link
  validates_format_of :media_link, with: URL_regex

#----------------------------------------end of mongo stuff-------------------------------#
end
