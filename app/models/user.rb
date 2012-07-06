class User < ActiveRecord::Base

	# This is added to use the authlogic gem
	# Author: Kiro
	acts_as_authentic	do |c|
		c.merge_validates_length_of_password_field_options :minimum => 6
	end

=begin

   This is added to use the amistad friendship Gem
   Author: Yahia
=end
  include Amistad::FriendModel
  include UsersHelper

  # attr_accessible :title, :body
  attr_accessible :name, :first_name, :last_name, :date_of_birth, :email, :deactivated, :twitter_account, :twitter_request, :image, :password, :password_confirmation, :new_password
  has_many :comments
  has_many :comment_up_downs
  # stat 0 pending
  # stat 1 requested
  # stat 2 accepted
  has_one :facebook_account
  has_one :twitter_account
	has_one :verification_code
  has_one :tumblr_account
  has_one :flickr_account
  has_many :shares
  has_many :shared_stories, :class_name => "Story", :through => :shares
  has_many :likedislikes
  has_many :likedisliked_stories, :class_name => "Story", :through => :likedislikes
  has_many :flags
  has_many :flaged_stories, :class_name => "Story", :through => :flags
  has_many :block_interests
  has_many :blocked_interests, :class_name => "Interest", :through => :block_interests
  has_many :block_stories
  has_many :blocked_stories, :class_name => "Story", :through => :block_stories 
  has_many :user_log_ins
  has_and_belongs_to_many :user_add_interests
  has_many :added_interests, :class_name => "Interest", :through => :user_add_interests

  has_many :user_add_interests
  has_many :added_interests, :class_name =>"Interest", :through => :user_add_interests 


  email_regex = /\A(?:\w+\.)*\w+@(?:[a-z\d]+[.-])*[a-z\d]+\.[a-z\d]+\z/i
  validates :name, :length => { :maximum => 20 }
  validates :email, :presence => true,
  :format=> {:with => email_regex },

  :uniqueness => { :case_sensitive => false}
  validates :first_name, :length => { :maximum => 20 }
  validates :last_name,  :length => { :maximum => 20 }

=begin  
 gets the shared stories of one friend given his/her id
 to get your own shared stories supply your own ID
 as the param friend id
 Input: int friend id whom I want to get stories from
 Output: story array
 Author: Menisy
=end  
  def get_one_friend_stories(friend_id) 
    user = User.find(friend_id)
    user.shared_stories
  end

=begin
   gets the users shared stories
   Inputs: none
   Author: Menisy
=end
  def get_shared_stories
    self.shared_stories
  end
=begin
  gets the shared stories of friends of a user
  Inputs: none
  Output: story array
  Author: Menisy
=end
  def get_friends_stories()
    friends = self.friends
    shared_stories = Array.new
    friends.each do |friend|
      shared_stories << friend.shared_stories
    end
    return shared_stories.flatten
  end

=begin  
 gets the users pending notifications
 only pending friendship requests for now
 Inputs: none
 Output: array of users who invited me
 Author: Menisy
=end
def get_notifications
  if self.pending_invited_by.empty?
    nil
  else
    self.pending_invited_by
  end
end

=begin 
#description: the get_friends is a method that return list of all friends email of the user
#input: No Input
#output: a list of emails of the user friends
#Author: khaled.elbhaey
=end 
  def get_friends_email()
  @flistemail=Array.new
  @flist = self.friends


    (0..(@flist.length-1)).each do |i|
    @flistemail << (@flist[i].email)
    end  

    return @flistemail

  end


=begin 
#description: has_account checks if the user with the (mail) is in our database or not
#input: email
#output: true if the user with the mail in DB and false otherwise
#Author: khaled.elbhaey
=end
  def has_account(mail)
  
    @email=mail
    if User.find_by_email(@email).nil?
       return false
    else
       return true
    end    

  end

=begin 
  This method takes a list of users and return a list users that are friends
  with the 'self'
  Input: List of users
  Output: Users who are both in the list and are friends with "self" 
  Author: Yahia
=end
  def extract_friends(users)
    return self.friends & users
  end

=begin
  lets a user share a story given its id
  Input: story_id
  Output: true
  The method before did not allow the user to
  share the same story twice, however this is 
  now allowed so no checks are neccessary.
  Author: Menisy
=end
  def share(story_id)
    self.shared_stories << Story.find(story_id)
    user_name = self.name  ||  self.email.split('@')[0]
    story = Story.find(story_id)
    story_title = story.title || story.content[0,20]+"..."
    p story_title.nil?
    p user_name.nil?
    Log.create!(loggingtype: 2,user_id_1: self.id,user_id_2: nil,admin_id: nil,story_id: story_id,interest_id: nil,message: user_name + " shared the story \"" +  story_title +  "\"" )
    return true
  end 
     
=begin  
  This method returns the number of users who signed in today.
  Input: No input
  Output: number
  Author : christinesed@gmail.com 
=end
  def self.get_no_of_users_signed_in_today
    no_sing_ins=UserLogIn.where(:created_at=>
    Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).
    uniq.pluck(:user_id).count
  end

 '''This method to get the number of users who registered per day
 first we check if there are users in the DB else we return an empty array
 
 case 1 if the creation day was within last 30 days:
 get all the users who registered within first user creation until the current 
 date and group by the date of creation
 then was to get the count of the users who registered per day and 0 if no user did

 case 2 if the creation date was before 30 days ago:
 get all the users who registered within 30 days ago until the current date and 
 group by the date of creation
 then get the count of the users who registered per day and 0 if no user did'''
 ##########Author: Diab ############
 def self.get_num_registered_day
 
 first_user = User.first

 if first_user.nil?
 
  registered_per_day = []

 else

  first_user_create_date = User.first.created_at
 
  if first_user_create_date >= 30.days.ago.to_date

   registered_per_day = User.where(:created_at => first_user_create_date.
   beginning_of_day..Time.zone.now.end_of_day).group("date(created_at)").
   select("created_at , count(id) as regs_day") 

   (first_user_create_date.to_date..Time.zone.now.to_date).map do |date|
   reg = registered_per_day.detect { |reg| reg.created_at.to_date == date}
   reg && reg.regs_day.to_i || 0
     end.inspect

  else
 
   registered_per_day = User.where(:created_at => 30.days.ago.beginning_of_day..
   Time.zone.now.end_of_day).group("date(created_at)")
   .select("created_at , count(id) as regs_day") 

   (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
   reg = registered_per_day.detect { |reg| reg.created_at.to_date == date}
   reg && reg.regs_day.to_i || 0
    end.inspect
 
   end
  end
 end


 '''This method to get the number of users who registered per day
 first we check if there are users in the DB else we return an empty array
 
 case 1 if the first login was within last 30 days
 get all the users who logged in within first user login until the current date 
 and group by the date of creation
 then get the count of the users who registered per day and 0 if no user did

 case 2 if the first user login was before 30 days ago
 get all the users who logged in within 30 days ago until the current date and 
 group by the date of creation
 then get the count of the users who registered per day and 0 if no user did
 '''
##########Author: Diab ############
 def self.get_num_logged_in_day

 first_user = UserLogIn.first

 if first_user.nil?

  logged_per_day = []

 else

 first_user_log_date = User.first.created_at 
 
 if first_user_log_date >= 30.days.ago.to_date

  logged_per_day = UserLogIn.where(:created_at => first_user_log_date
  .beginning_of_day..Time.zone.now.end_of_day).group("date(created_at)")
  .select("created_at , count(distinct(user_id)) as logs_day") 

  (first_user_log_date.to_date..Time.zone.now.to_date).map do |date|
  log = logged_per_day.detect { |log| log.created_at.to_date == date}
  log && log.logs_day.to_i || 0
   end.inspect

 else

  logged_per_day = UserLogIn.where(:created_at => 30.days.ago.beginning_of_date..
  Time.zone.now.end_of_day).group("date(created_at)")
  .select("created_at , count(distinct(user_id)) as logs_day")
  
  (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
  log = logged_per_day.detect { |log| log.created_at.to_date == date}
  log && log.logs_day.to_i || 0
     end.inspect

   end
 end
end

 '''to get the start day of the statistics graph

 case 1 if the creation day was within last 30 days:
 set the start date of the statistics to the creation of the first User
 
 case 2 if the creation date was before 30 days ago:
 set it to 30 days ago
 ''' 
 ##########Author: Diab ############
 def self.get_all_users_start_date

  first_user = User.first

 if first_user.nil?

   date=-1
 else

 first_user_create_date = User.first.created_at.to_date 
 
 if first_user_create_date >= 30.days.ago.to_date

 date = Time.zone.now.to_date - first_user_create_date 
 
 else

 date = Time.zone.now.to_date - 30.days.ago.to_date
 
   end
  end
 end
 
 #to get num of users registered in the system
 ##########Author: Diab ############
 def self.all_user_registered

 num = User.all.count
 
 end
 
#to get the number of registered users per day to use it in the graph
##########Author: Diab ############
 def self.get_registered_stat
 r = get_num_registered_day
 data = "[#{r}]"
 end

#to get the number of logged in users per day to use it in the graph
##########Author: Diab ############
 def self.get_logged_stat
 l = get_num_logged_in_day_h
 data = "[#{l}]"
 end
 #to get the number of registered and logged in users per day to use it in the graph
 def self.get_all_users_stat
 reg = get_num_registered_day
 log = get_num_logged_in_day
 if reg.empty?
 data = []
 else 
 data = "[#{reg},#{log}]"
 end
end

  '''
  This is the method that should return the data of statistics of a user
  with this format first element in the data arrays is ARRAY OF "No Of Shares",
  second one is "No Of Likes"
  third one is "No of Dislikes"
  and forth one is "No of Flags"
  and fifth one is "No of Comments"
  '''
  
 def get_user_stat(user_id)
  s = get_no_of_shares_user(user_id)
  n = get_no_of_likes_user(user_id)
  m = get_no_of_dislikes_user(user_id)
  p = get_no_of_flags_user(user_id)
  c = get_no_of_comments_user(user_id)
 data = "[#{s},#{n},#{m},#{p},#{c}]"
 end

=begin
  This method adds a twitter account to the user. The twitter
  account corresponds to the request_token received from twitter
  in the authentication phase

  Author: Yahia
=end
  def create_twitter_account(request_token)
    access_token = request_token.get_access_token
    old_account = self.twitter_account(true)
    if (old_account)
      old_account.destroy
    end
    self.twitter_account(true) #Reload cache     
    t_account = TwitterAccount.new
    t_account.auth_token = access_token.token
    t_account.auth_secret = access_token.secret
    t_account.user = self
    t_account.save
    return t_account
  end 

=begin
  This method removes the twitter account of 
  returns true if the removal was successfull 
  Author: Yahia
=end   
  def remove_twitter_account
    if (self.twitter_account)
      self.twitter_account.destroy
    else 
      false 
    end 
  end 

=begin 
  Checks if the user has a twitter account
=end 
  def has_twitter_account?
    if self.twitter_account.nil?
      return false
    else
      return true
    end 
  end
=begin
Description:his Action takes as parametars a story and action and checks if the user had thumbed this story or not,if the user didn't thumb a new record will be added in the Likedislike table with story_id , user_id and action , if thumbed before and tries to make the same action again .. nothing will happen if thumbed before and tries to make a diffrent action .. the old record will be destroyed and a new record with the new action will be added
Input: Story , Action [1 or -1]
Output: Nothing
Author: Kareem
=end
	def thumb_story(story,act)
		name_1 = if self.name.nil? then self.email.split('@')[0] else self.name end
		action_n = if act == 1 then "UP" else "Down" end
		thumped = Likedislike.where(:story_id => story.id, :user_id => self.id)
		if thumped.empty? 
				Likedislike.create!(:user_id => self.id, :story_id => story.id , :action => act)
				l = Log.create(:loggingtype => 2 , :user_id_1 => self.id , :story_id => story.id , :message => "#{name_1} Thumbed #{action_n} #{story.title}")
				puts "Thump"

		elsif (thumped[0].action == act) 
				Likedislike.find(:first , :conditions => ["user_id = ? AND story_id = ?" ,self.id , story.id]).destroy
				l = Log.create(:loggingtype => 2 , :user_id_1 => self.id , :story_id => story.id , :message => "#{name_1} un-Thumbed #{action_n} #{story.title}") 
				puts "Removed"
		elsif (thumped[0].action != act) 
				Likedislike.find(:first , :conditions => ["user_id = ? AND story_id = ?" ,self.id , story.id]).destroy
				Likedislike.create!(:user_id => self.id, :story_id => story.id , :action => act )
				l = Log.create(:loggingtype => 2 , :user_id_1 => self.id , :story_id => story.id , :message => "#{name_1} Thumbed #{action_n} #{story.title}")  
				puts "Removed _thumbed"
		end

	end

=begin
Description:this Action takes as a parametar a story and it checks if the current User flagged it before or not .. if not a new Record will be added in the Flags table with current user_id , current_story id else if he already flagged it nothing will happen.
Input: Story
Output: true or False
Author: Kareem
=end
	def flag_story(story)
		thumped = Flag.where(:story_id => story.id, :user_id => self.id)
		if thumped.empty?
				Flag.create!(:user_id =>  self.id, :story_id => story.id)
				#Admin_Settings.update_story_if_flagged(story)
				name_1 = if self.name.nil? then self.email.split('@')[0] else self.name end
				l = Log.create(:loggingtype => 2 , :user_id_1 => self.id , :story_id => story.id , :message => "#{name_1} Flagged Story #{story.title}")  
			return true
		end
			return false
	end
=begin
Description: this Action returns a list of stories according to the current user interests .. and it also checks if theses stories are blocked According to an Interest or its a Blocked story or not before it returns the List of stories,the method also takes as input Interest name if it's not "null" the method will return the stories filtered according to this interest only.
Input: Interest.name 
Output: returns List of stories according to the Description
Author: Kareem
=end
  def get_feed
	
    user_interests = UserAddInterest.find(:all , :conditions => ["user_id =?" , self.id ] , :select => "interest_id").map {|interest|interest.interest_id} 
    blocked_interests =  BlockInterest.select {|entry| self.id==entry.user_id }.map{|entry| entry.interest_id }
    unblocked_stories = Array.new
    unblocked_interests = user_interests - blocked_interests
    stories_list = Array.new
    #loop on the unblocked_interests Array and for each Interest call the get_stories method and returns it's corresponding stories
    unblocked_interests.each do |unblocked_interest|
  		stories_list +=  Interest.find(unblocked_interest).get_stories(10)
   	end
    stories_list = stories_list.sort_by &:created_at
 		stories_ids = stories_list.map {|story| story.id}
 		blocked_stories_ids = BlockStory.select { |entry| self.id==entry.user_id }.map  { |entry| entry.story_id }
 		unblocked_stories_ids = stories_ids - blocked_stories_ids
		#loop on the unblocked_stories_ids [Array] and get the story for each story_id and append it to the Array of unblocked_stories
  	unblocked_stories_ids.each do |unblocked_story_id|
        unblocked_stories.append(Story. find(unblocked_story_id))
    end
 		done_stories =   unblocked_stories
  	return done_stories
  end

=begin
Description:this method takes as input Array of stories and filter these Stories from the Blocked stories or Stories that belongs to an Interest that is Blocked.
Input:stories - Array of stories
Output:array of unblocked stories
Author:Kareem
=end
  def  get_unblocked_stories(stories)
		unblocked_stories = Array.new
		stories = stories.sort_by &:created_at
		stories_ids = stories.map {|story| story.id}
		blocked_stories_ids = BlockStory.select { |entry| self.id==entry.user_id }.map  { |entry| entry.story_id }
		blocked_interests =  BlockInterest.select {|entry| self.id==entry.user_id }.map{|entry| entry.interest_id }
		unblocked_stories_ids = stories_ids - blocked_stories_ids
		#loop on unblocked stories and for each unblocked_story_id we get the Story accrding to this Id and if this story doesn't belong 	an 
		# unblocked interest append it to unblocked_stories
		unblocked_stories_ids.each do |unblocked_story_id|
			story = Story.find(unblocked_story_id)
			if !(blocked_interests.include?(story.interest_id))
					unblocked_stories.append(story)
			end
		end
		return unblocked_stories	
	end
	
=begin
  This action returns the rank of one user
  Returns the rank of a user
  Author: Shafei
=end
  def get_user_rank
        i = 0
        User.all.each do |user|
                if (user.blocked? self) == true
                        i = i + 10
                end
        end
        rank = (self.comments.count * 2) + (self.user_log_ins.count * 2)
        rank = rank + self.likedislikes.where(action: 1).count + self.flags.count
        rank = rank + self.likedislikes.where(action: -1).count+(self.user_add_interests.count * 5)
        rank = rank + self.friends.count + (self.shares.count * 3) - i
        return rank
  end

=begin
  This action returns a list of all users in the database sorted according to their rank
  Returns a list of all users
  Author: Shafei
=end
  def self.get_users_ranking
        all_users = Array.new
        top_users = Array.new
        final_users = Array.new
        User.all.each do |user|
                all_users << {:rank => user.get_user_rank, :theuser => user}
        end
        (all_users.sort_by {|element| element[:rank]}).each do |hsh|
                final_users << hsh[:theuser]
        end
        top_users =  final_users.reverse
        if (top_users.empty? == true)
                return []
        else
                return top_users
        end
  end


  
=begin 
Discription: check if user toggle new interests the methods adds it to his interests if toggled old interest it deletes it from his interests and return msg discribing either interest is deleted or added
Input : Interest
Output : String
Author : Omar 
=end
 
 def toggle_interests(interest)
	
    id = interest.id
	 if self.name.nil?
	      username = self.email.split('@')[0]
         else
      	      username = self.name
         end
    interest_name = Interest.find(id).name
  
       if(self.added_interests.include?(interest))
	 	self.added_interests.delete interest
 		message = "#{username} deleted interest : #{interest_name}"
   		Log.create!(loggingtype: 3,user_id_1: self.id,user_id_2: nil, admin_id: nil, story_id: nil, 			interest_id: id, message: message)
   		return "Interest deleted."
       else 
		 UserAddInterest.create(:user_id => self.id , :interest_id => id)
 	      	 message = "#{username} added interest : #{interest_name}"
   		 Log.create!(loggingtype: 3,user_id_1: self.id,user_id_2: nil, admin_id: nil, story_id: nil, 			 interest_id: id, message: message)
   		 return "Interest added."
       end
 end
 
=begin
Description: this method returns the Interests names of the User's Interests
Input:
Output:Array of Interest names
Author:Kareem
=end

  def get_interests
 	  interests = UserAddInterest.find(:all , :conditions => ["user_id = ?" , self.id ] , :select => "interest_id").map {|interest| interest.interest_id}.map {|id| 		Interest.find(id).name}
	 return interests 
	end 

=begin
	Description: This method generated a verification code record
	for the user, where the verification code is a random 4 characters
	string containing digits and lowercase letters, and it sets the
	boolean verified field to false. This method returns true if
	the user has no verification code record yet, false otherwise
	Output: Boolean
	Author: Kiro
=end
  def generateVerificationCode?()
  		@verification_code = self.verification_code
      if @verification_code.nil? then
			entry = VerificationCode.new :code=>( (0..9).to_a + ('a'..'z').to_a).shuffle[0..3].join, :verified=>false
      self.verification_code = entry
      return true               
    else                        
      return false              
    end
  end 

=begin
	Description: This method checks if the code entered by the
	user matches his verification code, it returns true if it
	matches, false otherwise.
	Input: String (code entered by user)
	Output: Boolean
	Author: Kiro
=end
  def verifyAccount?(verCode)
    @verEntry = self.verification_code
    if @verEntry.code == verCode then
      @verEntry.update_attributes(verified: true)
      return true
    else 
      return false
    end
  end

=begin
  This method resendCode? resets the verification Code of the user's account and updates the
  verification code in the database by the new generated one.
  This method returns true if the accout wasnt verified yet, otherwise it returns false.
	Output: Boolean
  Author: Kiro
=end
  def resendCode?
    @varEntry = self.verification_code
    if @varEntry.verified
       return false
    else
    @varEntry.update_attributes(code: ( (0..9).to_a + ('a'..'z').to_a).shuffle[0..3].join)
       return true
    end
  end


=begin
  Description: This method blocks the interest by inserting a row in
  BlockInterest table.
  If the interest is already blocked, it responds with a message that the interest
  is already blocked.
  Input: interest
  Output: message to indicate success/failure of block
  Author: Rana
=end   
  def block_interest1(this_interest)
   this_user = self
   #checks if the interest is not already blocked.
   if !(this_user.blocked_interests.include? this_interest)
      this_user.blocked_interests << this_interest
      @text = "Interest blocked."
   #for log file in case of success of block
      if self.name.nil?
         @username = self.email.split('@')[0]
      else
         @username = self.name
      end
      @interesttitle =this_interest.name
      @message = "#{@username} blocked interest with name: #{@interesttitle}"
      Log.create!(loggingtype: 3,user_id_1: self.id,user_id_2: nil, admin_id: nil,
      story_id: nil, interest_id: this_interest.id, message: @message)
   else 
      @text = "Interest is already blocked."    
   end
   
   return @text #return the message in variable text
  end

=begin
  Description: This method unblocks the interest belonging to the story by 
  deleting the row in BlockInterest table.
  If the interest is already unblocked, it responds with a message that the 
  interest is already unblocked.
  Input: interest
  Output: message to indicate success/failure of unblock
  Author: Rana
=end   
  def unblock_interest1(this_interest)
   this_user = self
   #checks if the interest is not already unblocked.
   if (this_user.blocked_interests.include? this_interest)
      this_user.blocked_interests.delete this_interest
      @text = "Interest unblocked."
   #for log file in case of success of block
      if self.name.nil?
         @username = self.email.split('@')[0]
      else
         @username = self.name
      end
      @interesttitle =this_interest.name
      @message = "#{@username} unblocked interest with name: #{@interesttitle}"
      Log.create!(loggingtype: 3,user_id_1: self.id,user_id_2: nil, admin_id: nil,
      story_id: nil, interest_id: this_interest.id, message: @message)
   else 
      @text = "Interest is already unblocked."    
   end
   
   return @text #return the message in variable text
  end

=begin
  Description: This method takes a story id as input and blocks its story by 
  inserting a row in BlockStory table. 
  If the story is already blocked, it responds with a message that the story is
  already blocked.
  Input: story
  Output: message to indicate success/failure of block
  Author: Rana
=end
  def block_story1(this_story)
   this_user = self
   #if the story is not blocked, insert it in the block_story table
   if !(this_user.blocked_stories.include? this_story)
      this_user.blocked_stories << this_story
      @text = "Story blocked."
   #for log file in case of success of block
      if self.name.nil?
         @username = self.email.split('@')[0]
      else
         @username = self.name
      end
      @storytitle = this_story.title
      @message = "#{@username} blocked story with title: #{@storytitle}" 
      Log.create!(loggingtype: 2,user_id_1: self.id,user_id_2: nil, admin_id: nil,
      story_id: this_story.id, interest_id: nil, message: @message)
   else 
      @text = "Story is already blocked."
   end

   return @text #return the message in variable text
  end

=begin
  Description: This method unblocks a story by deleting its row in BlockStory 
  table.
  Input: story
  Output: text message to indicate success of unblock  
  Author: Rana
=end
  def unblock_story1(this_story)
   this_user = self
   # if it is blocked, delete its record
   if (this_user.blocked_stories.include? this_story)
      this_user.blocked_stories.delete this_story
      @text = "Story unblocked."
      #for log file in case of success of unblock
      if self.name.nil?
        @username = self.email.split('@')[0]
      else
        @username = self.name
      end
      @storytitle = this_story.title
      @message = "#{@username} unblocked story with title: #{@storytitle}" 
      Log.create!(loggingtype: 2,user_id_1: self.id,user_id_2: nil, admin_id: nil,
      story_id: this_story.id, interest_id: nil, message: @message)
   else
      @text = "Story is already unblocked."
   end
   return @text #return the message in variable text
  end

=begin
  Description: This method gets the blocked stories of the user from the 
  BlockStory table.
  Input: no input
  Output: array of stories 
  Author : Rana
=end
  def get_blocked_stories
   this_user = self
   return this_user.blocked_stories
  end

=begin
  Description:This method blocks a user's friend using the block method provided 
  by the gem amistad.
  It first checks if the friend is already blocked or not.
  Input: friend
  Output: text message to indicate success/failure
  Author: Rana
=end
  def block_friends_feed1(my_friend)
    @this_user = self
    if(!(@this_user.blocked? my_friend))
        @this_user.block (my_friend)
        @text = "#{my_friend.email} blocked."
       #for log file in case of success of block
       if self.name.nil?
          @username = self.email.split('@')[0]
       else
          @username = self.name
       end
       if my_friend.name.nil?
          @frname = my_friend.email.split('@')[0]
       else
          @frname = my_friend.name
       end
       @message = "#{@username} blocked friend named: #{@frname}" 
       Log.create!(loggingtype: 0,user_id_1: self.id,user_id_2: my_friend.id ,
       admin_id: nil, story_id: nil, interest_id: nil, message: @message)
    else
        @text = "#{my_friend.email} is already blocked."
    end

    return @text #return the message in variable text
  end

=begin
  Description: This method takes unblocks a user's friend using the unblock method 
  provided by the gem amistad.
  Input: friend
  Output: text message to indicate success
  Author: Rana
=end
  def unblock_friends_feed1(my_friend)
     if(self.blocked? my_friend)
       self.unblock my_friend
       @text = "#{my_friend.email} unblocked."
       #for log file in case of success
       if self.name.nil?
        @username = self.email.split('@')[0]
       else
        @username = self.name
       end
       if my_friend.name.nil?
        @frname = my_friend.email.split('@')[0]
       else
        @frname = my_friend.name
       end
       @message = "#{@username} unblocked friend named: #{@frname}" 
       Log.create!(loggingtype: 0,user_id_1: self.id,user_id_2: my_friend.id ,
       admin_id: nil, story_id: nil, interest_id: nil, message: @message)
     else
       @text = "#{my_friend.email} is already unblocked."
     end
     return @text #return the message in variable text
  end

=begin
    # issue 89
    # A method called to get stories from social accounts conected to the current user
    # returns a list of stories shuffled 
    # checks the four social networks we have in our system and sees whether 
    # the user connected to them or not, then
    # calls the get_feed method in each network
    # input : no input
    # output : list of stories of connected social accounts
    # Author : Essam Hafez
=end
   def get_social_feed()
     user = self
     social_stories = Array.new #Initialize new empty array
    if(!user.twitter_account.nil?) # if user has twitter account then enters if
       social_stories = social_stories + (user.twitter_account.get_feed) # appends twitter feed to list
     end
     if(!user.tumblr_account.nil?) #if user has tumblr account then enters if
       social_stories = social_stories + (user.tumblr_account.get_feed) #appends tumblr feed to list
     end
     if(!user.facebook_account.nil?) # if user has facebook account then enters if
       social_stories = social_stories + (user.facebook_account.get_feed) #appends facebook feed to list
     end
     if(!user.flickr_account.nil?) # if user has flickr account then enters if
       social_stories = social_stories + (user.flickr_account.get_feed) # appends flickr feed to list
     end
     return social_stories.shuffle # returned stories shuffled
   end
   

    
=begin 
    # issue 88
    # a method called when the user wants to see a specific feed
    # if the user wants to filter the view of any social account he is connected to 
    # he calls this method with the id of the social network then a list of stories of this account is returned
    # twitter => id = 1
    # facebook => id = 2
    # flickr => id = 3
    # tumblr => id = 4
    # Input: social network id
    # output: list of stories of this social network
    # Author : Essam Hafez
=end

  def filter_social_network (socialID)
    user = User.find(self.id)
    if(socialID == 1)
      return user.twitter_account.get_feed
    elsif (socialID == 2)
      return user.facebook_account.get_feed
    elsif (socialID == 3)
      return user.flickr_account.get_feed
    elsif (socialID == 4)
      return user.tumblr_account.get_feed
    else
      return []
    end
  end

=begin
	Description: This method generates a new password for the user
	and updates it in the database, this password generated is
	a 6 character string containing digits and letters (lower case
	and upper case), and it returns the new password.
	Output: String (The new password)
	Author: Kiro
=end
	def resetPassword
	
		newpass = ((0..9).to_a + ('a'..'z').to_a + ('A'..'Z').to_a ).shuffle[0..5].join
		self.new_password = newpass
		self.save
		return newpass
	
	end

=begin  
  get recent Activity of user from the passed start date
  Parameters : start_date (date that the recent Activity will be calculated from)
  Author: Christine
=end
  
  def get_recent_activity(start_date)
    activities=Log.get_log_for_user(self.id,start_date)
  end
=begin
These methods simply take the user id as an input , fetch him from the database and change his deactivated attribute
to the right value
Inputs: non
Outputs: non
Author: Bassem
=end
  def deactivate_user()
    self.deactivated = true
   Emailer.notify_deactivation(self).deliver
    self.save
  end

  def activate_user()
    self.deactivated = false
    Emailer.notify_activation(self).deliver
    self.save
  end
=begin
Description: This method takes as Input an Interest and returns 10 Stories Under this Interest and Filters them from the Blocked One's
Input : Interest
Output: Array of Stories - related to this Interest
Author: Kareem
=end
	def get_interest_stories(interest)
				stories = interest.get_stories(10)
				unblocked_stories = get_unblocked_stories(stories)
				return unblocked_stories
	end

=begin	
  Description: This method is not included in the Gem "amistad" yet we need it 
               therefore, it's not very efficient because of the lack of a proper data
               structuture 
  Input : Nothing
  Ouput : users who blocked self.
=end
  def blockers
    blockers = Array.new
    for u in User.all
      if u.blocked? self
        blockers << u
      end 
    end 
    return blockers
  end 


end
