class Feed
	include Mongoid::Document
	field :link, type: String
	belongs_to :interest_id

#attributes  that can be modified automatically by outside users
  #attr_accessible  :link, :interest_id
  #belongs_to :interest
 # RSS feed link has to be of the form "http://www.abc.com"
  LINK_regex = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix
    # link ignores upper/lower cas issue
  validates :link,  :presence => true,
            :format   => { :with => LINK_regex },
# this uniqueness line is to ensure that the compsite key ( link + interest_id is uniQue ) and this is to give the other  different interests the chance to add the same link 
            :uniqueness => {:scope => :interest_id , :case_sensitive => false}

#interest _id should be there to create the RSS feed 
  validates :interest_id, :presence => true

# author : Mouaz			 
# get_feed is a method that takes a specific feed_id as an input  and searches the database 
# for the feed with this id and returns #this feed to the caller

  def self.get_feed(feed_id)
      return Feed.find(feed_id)
  end

# author : Mouaz			 
# get_feed is a method that takes a specific feed_link as an input  and searches the database 
# for the feed with this id and returns #this feed to the caller

  def self.get_feed_by_link(feed_link)
      return Feed.find_by_link(feed_link)
  end
end
