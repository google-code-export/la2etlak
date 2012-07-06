class Story < ActiveRecord::Base

include StoriesHelper
#definition of some attributes:-
# :rank==>hottness of a story, :interest_id==>id of the related interest,
# :type==> 1 (Article) 2 (Image) 3 (video)
  attr_accessible :interest_id, :title, :date, :rank, 
		  :media_link, :category, :content, :deleted, :hidden
  belongs_to :interest
  has_many   :comments
  
  
  has_many :shares
  has_many :sharers, :class_name => "User", :through => :shares
  has_many :likedislikes
  has_many :likedislikers, :class_name => "User", :through => :likedislikes
  has_many :flags
  has_many :flagers, :class_name => "User", :through => :flags
  has_many :block_stories
  has_many :blockers, :class_name => "User", :through => :block_stories 
  
  #def initialize(title, date, body)
   # @title = title
    #@body = body
  #end

  URL_regex = /^(?:(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(?::[0-9]{1,5})?(\/.*)?)|(?:^$)$/ix
# putting some validations on the title and interest_id that they are present
  validates :title , :presence=>true
  validates :interest_id, :presence=>true
# checking that the media_link is a valid URL according to the regex defined above.
  validates :media_link, :format=> {:with => URL_regex}

# author : Gasser			 
# get_story is a method that takes a specific story_id as an input  and searches the database 
# for the stroy with this id and returns #this story to the caller

  def self.get_story(story_id)
      return Story.find(story_id)
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
   
    share = get_no_of_activity(shares, creation_date, last_update, hidden)
    like = get_no_of_activity(likedislikes.where(:action => 1) , creation_date, last_update, hidden)
    dislike = get_no_of_activity(likedislikes.where(:action => -1), creation_date, last_update, hidden)
    flag = get_no_of_activity(flags, creation_date, last_update, hidden)
    comment = get_no_of_activity(comments, creation_date, last_update, hidden)
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
    likers = likedislikes.where(action: 1).map {|like| User.find(like.user_id)}
  end
  
  
=begin
  This method returns a list of users who disliked a certain story
  Author: Lydia
=end
  def disliked
    dislikers = likedislikes.where(action: -1).map {|dislike| User.find(dislike.user_id)}
  end
  
=begin
  This action returns the rank of one story since the day it was created
  Author: Shafei
=end
  def get_story_rank_all_time
	rank = (self.shares.count * 5) + self.comments.count
	rank = rank + (self.likedislikes.where(action: 1).count * 2) - (self.flags.count * 5)
	rank = rank - (self.likedislikes.where(action: -1).count * 2)
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
	top_stories = Array.new
    final_stories = Array.new
	Story.all.each do |story|
		all_stories << {:rank => story.get_story_rank_all_time, :thestory => story}
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
    top_stories = Array.new
    final_stories = Array.new
    Story.all.each do |story|
		all_stories << {:rank => story.get_story_rank_all_time, :thestory => story}
    end
    (all_stories.sort_by {|element| element[:rank]}).each do |hsh|
		final_stories << hsh[:rank]
    end
    top_stories =  final_stories.reverse
    if (top_stories.empty? == true)
		return []
    else
		return top_stories
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



end
