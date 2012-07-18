class Story
#Author: Akila ------------------------------------Mongo Stuff------------------------------------
  include Mongoid::Document
  include Mongoid::Timestamps
  include StoriesHelper
#definition of some attributes:-
# :rank==>hottness of a story, :interest_id==>id of the related interest,
# :type==> 1 (Article) 2 (Image) 3 (video)

#Fields:
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
  has_many :sharers, class_name: "User", :through => :shares
  has_many :likedislikes
  has_many :likedislikers, class_name: "User", :through => :likedislikes
  has_many :flags
  has_many :flagers, class_name: "User", :through => :flags
  has_many :block_stories
  has_many :blockers, class_name: "User", :through => :block_stories 
  
#Validations
  URL_regex = /^(?:(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(?::[0-9]{1,5})?(\/.*)?)|(?:^$)$/ix
# putting some validations on the title and interest_id that they are present
  validates_presence_of :title
  validates_presence_of :interest_id
# checking that the media_link is a valid URL according to the regex defined above.
  validates_presence_of :media_link
  validates_format_of :media_link, with: URL_regex

#----------------------------------------end of mongo stuff-------------------------------#

# author : Gasser			 
# get_story is a method that takes a specific story_id as an input  and searches the database 
# for the stroy with this id and returns #this story to the caller

  def self.get_story(story_id)
      return Story.find(story_id)
  end

  # A method that gets the story with this link
  def self.get_story_by_link (media_link)
    return Story.find_by_story_link(media_link)
  end 

  # A method that gets the story with this title
  def self.get_story_by_title (title)
    return Story.find_by_title(title)
  end

  # A method that gets all the stories of a certain interest
  def self.get_stories_by_interest (interest_id)
    return Story.find_all_by_interest_id (interest_id)
  end
  '''
  This method gets the number of a certain activity (shares, likes, dislikes, 
  flags) of a certain story using its id in each day in the last 30 days.
  There are several cases, concerning the date of creation, last update and
  hiding of the story, that has to handeled:
  1) If the story was created and hidden within the last 30 days, then I only 
  return the activity from the table between the creation date and the last 
  update which is the hiding.
  2) If the story was created before the last 30 days and hidden within the last
  30 days, then I only return the activity from the table between the last 30 
  days and the last update which is the hiding.
  3) If the story was created and hidden before the last 30 days, then I will 
  return an empty array.
  4) If the story was not hidden and it was created before the last 30 days, 
  then I return the activity from the table between the last 30 days and the 
  current date.
  5) If the story was not hidden and it was created within the last 30 days, 
  then I return the activity from the table between the creation date of the 
  story and the current date.
  '''
  # Author:Lydia
  def self.get_no_of_activity(needed_graph, creation_date, last_update, hidden)
    activities_by_day=[]
    if hidden && creation_date >= 30.days.ago.to_date && 
       last_update >= 30.days.ago.to_date
        days= (Time.zone.now.to_date - creation_date.to_date).to_i
        days2= (Time.zone.now.to_date - last_update.to_date).to_i
        (days.downto(days2)).each do |i|
            activities_by_day<<needed_graph.where(:created_at=> i.days.ago.beginning_of_day..i.days.ago.end_of_day).count
           end
          return activities_by_day
      
    elsif hidden && creation_date < 30.days.ago.to_date && 
          last_update >= 30.days.ago.to_date
          days= (Time.zone.now.to_date - last_update.to_date).to_i
          (30.downto(days)).each do |i|
            activities_by_day<<needed_graph.where(:created_at=> i.days.ago.beginning_of_day..i.days.ago.end_of_day).count
           end
          return activities_by_day
      
    elsif hidden && creation_date < 30.days.ago.to_date && 
          last_update < 30.days.ago.to_date
      activities_by_day = []
      
    elsif creation_date < 30.days.ago.to_date
      (30.downto(0)).each do |i|
        activities_by_day<<needed_graph.where(:created_at=> i.days.ago.beginning_of_day..i.days.ago.end_of_day).count
       end
       return activities_by_day
    else
      days= (Time.zone.now.to_date - creation_date.to_date).to_i
      (days.downto(0)).each do |i|
        activities_by_day<<needed_graph.where(:created_at=> i.days.ago.beginning_of_day..i.days.ago.end_of_day).count
       end
       return activities_by_day
    end
  end

  #Author: Lydia
  '''
  This method returns the percentage of the likes to the total number 
  of likes and dislikes
  '''
  def get_width
    likes =  self.likedislikes.where(action: 1).count
    dislikes =  self.likedislikes.where(action: -1).count
    total = likes + dislikes
    if total == 0
      width = 0
    else 
      width = likes*100/total
    end
  end


  #Author: Lydia
  ''' 
  This is the method that should return the data of statistics of a story
  with this format first element in the data arrays is ARRAY OF "No Of Shares",
  second one is "No Of Likes",
  third one is "No of Dislikes",
  forth one is "No of Flags",
  and fifth one is "No of Comments"
  '''
  def get_story_stat
    creation_date = created_at.beginning_of_day
    last_update = updated_at.end_of_day
   
    share = Story.get_no_of_activity(shares, creation_date, last_update, hidden)
    like = Story.get_no_of_activity(likedislikes.where(:action => 1) , creation_date, last_update, hidden)
    dislike = Story.get_no_of_activity(likedislikes.where(:action => -1), creation_date, last_update, hidden)
    flag = Story.get_no_of_activity(flags, creation_date, last_update, hidden)
    comment = Story.get_no_of_activity(comments, creation_date, last_update, hidden)
    data = "[#{share},#{like},#{dislike},#{flag},#{comment}]"
  end
  
  #Author: Lydia
   '''
   This method returns the difference between today and the day
  the story was created in in days so that the graph will know the day it should 
  start with.
  There are several cases:
  -case 1: if the story is hidden and it was created before the last 30 days
  but hidden within the last 30 days OR if the story was not hidden but created
  before the last 30 days
  -case 2: if the story was hidden and it was created before the last 30 days
  and hidden before the last 30 days
  -case 3: if the story was not hidden and it was created within the last 30 days
  '''
  def get_story_start_date
    creation_date = created_at.beginning_of_day
    last_update = updated_at.end_of_day  
    
    if (hidden && creation_date.to_date < 30.days.ago.to_date && 
          last_update.to_date >= 30.days.ago.to_date) ||
          (creation_date.to_date < 30.days.ago.to_date)
            date = Time.zone.now.to_date - 30.days.ago.to_date
    
    elsif hidden && creation_date.to_date < 30.days.ago.to_date && 
          last_update.to_date < 30.days.ago.to_date
            date = -1
            
    else
            date = Time.zone.now.to_date - creation_date.to_date
    end
  end

=begin  
  This method returns a list of users who liked a certain story
  Author: Lydia 
=end
  def liked
    i = self.id
    tmp = likedislikes.where(:action => 1 , :story_id => i).select(:user_id)
    likers = User.where(:id=>tmp)
  end
  
  
=begin
  This method returns a list of users who disliked a certain story
  Author: Lydia , Modified : Diab
=end
  def disliked
    i = self.id
    tmp = likedislikes.where(:action => -1 , :story_id => i).select(:user_id)
    dislikers = User.where(:id=>tmp)
  end
  
=begin
  This action returns the rank of one story since the day it was created
  Author: Shafei
=end
  def get_story_rank_all_time
  	rank = (self.shares.find(:all, :select => "id").count * 5) + self.comments.find(:all, :select => "id").count
	rank = rank + (self.likedislikes.find(:all, :select => "action", :conditions => {action: 1}).count * 2) - (self.flags.find(:all, :select => "id").count * 5)
	rank = rank - (self.likedislikes.find(:all, :select => "action", :conditions => {action: -1}).count * 2)
	return rank
  end
=begin  
  This action returns the rank of one story in the last 30 days
  Author: Shafei
=end
  def get_story_rank_last_30_days
	rank = (self.shares.where(created_at: 30.days.ago..Time.zone.now.end_of_day).count * 5)
	rank = rank + self.comments.where(created_at: 30.days.ago..Time.zone.now.end_of_day).count
	rank = rank + (self.likedislikes.where(action: 1,
	created_at: 30.days.ago..Time.zone.now.end_of_day).count * 2)
	rank = rank - (self.flags.where(created_at: 30.days.ago..Time.zone.now.end_of_day).count * 5)
	rank = rank - (self.likedislikes.where(action: -1, 
	created_at: 30.days.ago..Time.zone.now.end_of_day).count * 2)
	return rank
  end

=begin
  This action returns a list of all stories sorted according to their rank since the day they were created
  Author: Shafei
=end

  def self.get_stories_ranking_all_time
    all_stories = Array.new
    final_stories = Array.new
    Story.all.each do |story|
      all_stories << {:rank => story.get_story_rank_all_time, :thestory => story}
    end
    xstories=((all_stories.sort_by {|element| element[:rank]}).reverse)
    xstories.each do |hsh|
      final_stories << hsh[:thestory]
    end
    if (final_stories.empty? == true)
      return []
    else
      return final_stories
    end
  end

  
=begin
  This action returns a list of all stories sorted according to their rank in the last 30 days
  Author: Shafei
=end
  def self.get_stories_ranking_last_30_days
	all_stories = Array.new
    top_stories = Array.new
    final_stories = Array.new
    Story.all.each do |story|
		all_stories << {:rank => story.get_story_rank_last_30_days, :thestory => story}
    end
    (all_stories.sort_by {|element| element[:rank]}).each do |hsh|
		final_stories << hsh[:thestory]
    end
    top_stories =  final_stories.reverse
    if (top_stories.empty? == true)
		return []
	else
		return top_stories
	end
  end
  
=begin
  This action returns a list of the ranking of all stories
  Author: Shafei
=end
  def self.get_stories_ranking_all_time_rank
    all_stories = Array.new
    final_stories = Array.new
    Story.all.each do |story|
      all_stories << {:rank => story.get_story_rank_all_time, :thestory => story}
    end
    xstories=((all_stories.sort_by {|element| element[:rank]}).reverse)
    xstories.each do |hsh|
      final_stories << hsh[:rank]
    end
    if (final_stories.empty? == true)
      return []
    else
      return final_stories
    end
  end

=begin 
#description: view_friends_like is a method that return a list of friends emails that liked the story
#input: a user
#output: a list of names of friends who liked this story
#Author: khaled.elbhaey
=end
  def view_friends_like(user)
    @user=user
    @flistliked=Array.new
    @listlike = self.liked() 
    @flistlike=@user.extract_friends(@listlike)

    (0..(@flistlike.length-1)).each do |i|
    @flistliked << (@flistlike[i].email)
    end  

    return @flistliked

  end


=begin 
#description: view_friends_dislike is a method that return a list of friends emails that disliked the story
#input: a user
#output: a list of names of friends who disliked this story
#Author: khaled.elbhaey
=end
  def view_friends_dislike(user)
    @user=user
    @flistdisliked=Array.new
    @listdislike = self.disliked() 
    @flistdislike=@user.extract_friends(@listdislike)

     (0..(@flistdislike.length-1)).each do |i|
     @flistdisliked << (@flistdislike[i].email)
     end  

     return @flistdisliked

  end

=begin
Description: this method takes as input a user and returns "action" which should be a Likedislike table record .. if the User Liked this Story
Input:takes a User as input
Output:Nothing
Author:Kareem
=end
 def check_like(user)
   action = Likedislike.find(:all , :conditions => ["story_id = ? AND user_id = ? AND action = ?", self.id, user.id , "1"])
 end

#the same Description as the check_like(user)

 def check_dislike(user)
    action = Likedislike.find(:all , :conditions => ["story_id = ? AND user_id = ? AND action = ?", self.id, user.id , "-1"])
 end
 
=begin
 This method checks the three booleans (hidden, flagged, checked) and queries the corresponding stories form the database
 All of these conditions append a sublist of stories to the array "stories" and then returns an array of unique stories.
 Inputs: 3 flags, hidden, flagged and active
 Output: Array of stories according to the input flags
 Author: Bassem
=end
 def self.filter_stories(hidden,flagged,active)
  stories = []
  stories3=[]

  #The hidden boolean gets all the hidden stories form the database
   if hidden
    stories1 =  Story.where("hidden = ? ", true)
    stories= stories + stories1
  end
  #The Flagged boolean loops in the table "Flag" and adds whatever stories it finds by taking its id and fetching it from
 #table "Story"
    if active
    stories2 = Story.where("hidden = ? AND deleted = ?", false, false)
    stories= stories + stories2
  end

  #The active boolean gets all the stories that are not hidden nor deleted from the database
  if flagged
    Flag.find_each do |flag|
      stories3 << Story.find(flag.story_id)
    end
    stories= stories + stories3

  end 
  stories = stories.sort_by { |obj| obj.created_at }.reverse
  return stories.uniq
 end

=begin
Discription : return list of top ranked  stories related to current story interest 
Input : no input
Output: list of stories
Author: Omar
=end

 def get_related_stories
 	stories =  Story.get_stories_ranking_all_time
	st = Array.new
	for story in stories 
		if(story.interest.id == self.interest.id && story!=self)
			st << story
		end
	end
	return st 
	
 end

=begin
  This Method to get the sharers of the story
=end  
  def sharers
    i = self.id
    tmp = Share.where(:story_id => i).select(:user_id)
    sharers = User.where(:id=>tmp)
  end

end
