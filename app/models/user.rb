class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
	field :name, type: String
	field :first_name, type: String
	field :last_name, type: String
	field :date_of_birth, type: Date
	field :deactivated, type: Boolean
	field :image, type: String
	field :new_passowrd, type: String

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

<<<<<<< HEAD
<<<<<<< HEAD
###########################################################################################3

=begin 
#description: has_account checks if the user with the (mail) is in our database or not
#input: email
#output: true if the user with the mail in DB and false otherwise
#Author: khaled.elbhaey
=end
  def has_account(mail)
  
    @email=mail
    if User.find_by(email: @email).nil?
       return false
    else
       return true
    end    

  end

  def self.all_user_registered

  	num = User.all.count
 
  end

=begin
  This to replace the shared_stories through
  Author: 3OBAD 
=end

  def shared_stories
		tmp = Share.where(:user_id => self.id).entries.map {|x| Story.find_by(:id => x.story_id)}
  end

=begin
  This to replace the likedisliked_stories through
  Note that this is not used anywhere else
  Author: 3OBAD 
=end

  def likedisliked_stories
    tmp = Likedislike.where(:user_id => self.id).select(:story_id)
    likedisliked_stories = Story.where(:id => tmp)
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
  def share_share(story_id)
    self.shared_stories << Story.find(story_id)
    user_name = self.name  ||  self.email.split('@')[0]
    story = Story.find(story_id)
    story_title = story.title || story.content[0,20]+"..."
    p story_title.nil?
    p user_name.nil?
    #Log.create!(loggingtype: 2,user_id_1: self.id,user_id_2: nil,admin_id: nil,story_id: story_id,interest_id: nil,message: user_name + " shared the story \"" +  story_title +  "\"" )
    return true
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
    for u in User.all.entries
      if u.blocked? self
        blockers << u
      end 
    end 
    return blockers
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

=======
=======
>>>>>>> 9440a2f0a08aab2e3d20a6c5af3fa60b11f313d4
=begin 
  This method to get the number of users who registered per day
 first we check if there are users in the DB else we return an empty array
 
 case 1 if the creation day was within last 30 days:
 get all the users who registered within first user creation until the current 
 date and group by the date of creation
 then was to get the count of the users who registered per day and 0 if no user did

 case 2 if the creation date was before 30 days ago:
 get all the users who registered within 30 days ago until the current date and 
 group by the date of creation
 then get the count of the users who registered per day and 0 if no user did
 ##########Author: Diab ############
=end 
 def self.get_num_registered_day
 
 first_user = User.first
 all_users= User.all
 if first_user.nil?
 
  registered_per_day = []

 else

  first_user_create_date = User.all.sort_by { |usr| usr[:created_at]}.first.created_at.to_date
  registered_per_day=[]
  days=get_all_users_start_date.to_i
 
  if first_user_create_date >= 30.days.ago.to_date
    (days.downto(0)).each do |i|
      registered_per_day<<all_users.select{|x| x.created_at >= i.days.ago.beginning_of_day and x.created_at <= i.days.ago.end_of_day}.count
    end
    return registered_per_day
  else
    (30.downto(0)).each do |i|
      registered_per_day<<all_users.select{|x| x.created_at >= i.days.ago.beginning_of_day and x.created_at <= i.days.ago.end_of_day}.count
    end
    return registered_per_day
   end
  end
 end

=begin 
  This method to get the number of users who registered per day
 first we check if there are users in the DB else we return an empty array
 
 case 1 if the first login was within last 30 days
 get all the users who logged in within first user login until the current date 
 and group by the date of creation
 then get the count of the users who registered per day and 0 if no user did

 case 2 if the first user login was before 30 days ago
 get all the users who logged in within 30 days ago until the current date and 
 group by the date of creation
 then get the count of the users who registered per day and 0 if no user did
 ##########Author: Diab ############
=end 
 def self.get_num_logged_in_day

 first_user = UserLogIn.first
 logsall=UserLogIn.all.entries

 if first_user.nil?

  logged_per_day = []

 else

 first_user_create_date = User.all.sort_by { |usr| usr[:created_at]}.first.created_at.to_date
  logged_per_day=[]
  days=get_all_users_start_date.to_i
 
 if first_user_create_date >= 30.days.ago.to_date
  (days.downto(0)).each do |i|
      logged_per_day<<logsall.select{|log| log.created_at>= i.days.ago.beginning_of_day && log.created_at <= i.days.ago.end_of_day}.map{|x| x.user_id}.uniq.count
    end
    return logged_per_day
 else

  (30.downto(0)).each do |i|
      logged_per_day<<logsall.select{|log| log.created_at>= i.days.ago.beginning_of_day && log.created_at <= i.days.ago.end_of_day}.map{|x| x.user_id}.uniq.count
    end
    return logged_per_day
   end
 end
end

=begin 
  
  to get the start day of the statistics graph

 case 1 if the creation day was within last 30 days:
 set the start date of the statistics to the creation of the first User
 
 case 2 if the creation date was before 30 days ago:
 set it to 30 days ago 
 ##########Author: Diab ############
=end 
 def self.get_all_users_start_date

  first_user = User.first

 if first_user.nil?

   date=-1
 else

 first_user_create_date = User.all.sort_by { |usr| usr[:created_at]}.first.created_at.to_date 
 
 if first_user_create_date >= 30.days.ago.to_date

 date = Time.zone.now.to_date - first_user_create_date 
 
 else

 date = Time.zone.now.to_date - 30.days.ago.to_date
 
   end
  end
 end 

##########Author: Diab ############
 def self.get_all_users_start_date

  first_user = User.first

 if first_user.nil?

   date=-1
 else

 first_user_create_date = User.all.sort_by { |usr| usr[:created_at]}.first.created_at.to_date 
 
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

=begin

  This is the method that should return the data of statistics of a user
  with this format first element in the data arrays is ARRAY OF "No Of Shares",
  second one is "No Of Likes"
  third one is "No of Dislikes"
  and forth one is "No of Flags"
  and fifth one is "No of Comments"
  Author : Shafei
=end
  
 '''def get_user_stat(user_id)
  s = User.get_no_of_shares_user(user_id)
  n = User.get_no_of_likes_user(user_id)
  m = User.get_no_of_dislikes_user(user_id)
  p = User.get_no_of_flags_user(user_id)
  c = User.get_no_of_comments_user(user_id)
 data = "[#{s},#{n},#{m},#{p},#{c}]"
 end'''
>>>>>>> 9440a2f0a08aab2e3d20a6c5af3fa60b11f313d4

end
