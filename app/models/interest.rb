class Interest < ActiveRecord::Base
#Author: jailan
#attributes  that can be modified automatically by outside users
  attr_accessible :description, :name, :deleted, :photo  
  has_many :stories
  has_many :feeds, :dependent => :destroy

#the attached file we migrated with the interest to upload the interest's image from the Admin's computer
  has_attached_file :photo, :styles => { :small => "150x150>" },
                    :url  => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"
#here we validate the an Image should be specified with a certain size & type
#validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

 # RSS feed link has to be of the form "http://www.abc.com"
  LINK_regex = /^(?:(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(?::[0-9]{1,5})?(\/.*)?)|(?:^$)$/ix
 
  # name cannot be duplicated and has to be there .

  validates :name, :presence => true,
                   :uniqueness => {:case_sensitive => false},
                   :length   => { :maximum => 20 }

                 

  has_many :block_interests
  has_many :blockers, :class_name => "User", :through => :block_interests
  has_many :user_add_interests
  has_many :adding_users, :class_name => "User", :through => :user_add_interests

#description can never exceed 240 characters .
  validates :description,  :length   => { :maximum => 100 }

#a method that takes a number and returns this number of stories related to this interest
  def get_stories(stories_number=10)
# querying the related stories to the passed interest and take only the number given in the method
    self.stories [0..stories_number-1]
  end

def self.get_all_interests
Interest.all
end

 #This method when called will return an array of ActiveRecords having 
  #all interests in the database that are not deleted.
  def self.get_all_interests_for_users
     interests=Interest.where(:deleted => nil)
  end

  '''This method when called will return the difference between today and the day
  the interest was created in days.

  first to get when the interest was created
  then to get when the interest was updated last time
  then check if the interest is deleted or not
  
  the cases are
  case 1 if the interest is deleted and it is created within the last 30 day
  but its last update was within the last 30 days
  case 2 if the interest is deleted and its created before the last 30 days
  case 3 if the interest is deleted and its created before the last 30 days 
  and its last update was before the last 30 days
  case 4 if the interest is not deleted and its created before the last 30 days
  case 5 if the interest is not deleted and its created within the last 30 days'''
  ##########Author: Diab ############
  def self.get_interest_start_date(interest_id)

  interest_create_date = Interest.find(interest_id).created_at.to_date   
  interest_last_update_date = Interest.find(interest_id).updated_at.to_date   
  deleted = Interest.find(interest_id).deleted_before_type_cast 
  
  
  
  if deleted && interest_create_date >= 30.days.ago.to_date &&
     interest_create_date >= 30.days.ago.to_date

      date = Time.zone.now.to_date - interest_create_date
   
  
  elsif deleted && interest_create_date < 30.days.ago.to_date && 
        interest_create_date >= 30.days.ago.to_date

      date = Time.zone.now.to_date - 30.days.ago.to_date
  
  elsif deleted && interest_create_date < 30.days.ago.to_date && 
        interest_create_date < 30.days.ago.to_date

      date = -1
  
  elsif interest_create_date < 30.days.ago.to_date

      date = Time.zone.now.to_date - 30.days.ago.to_date
  
  else

      date = Time.zone.now.to_date - interest_create_date

   end
  end
  


  '''this method when called will get the number of stories in an interest for 
     each day.
  first to get when the interest was created
  then to get when the interest was updated last time
  then check if the interest is deleted or not
  
  the cases are
  
  case 1 if the interest is deleted and it is created within the last 30 day
  but its last update was within the last 30 days:
  get all the stories within the creation and deletion of the interest and 
  group by the date of creation then get the count of the stories added to the 
  interest per day and 0 if no stories were added
  
  case 2 if the interest is deleted and its created before the last 30 days:
  first get all the stories within the last 30 days and the last update of the 
  interest and group by the date of creation.
  then get the count of the stories added to the interest per day and 0 if
  no stories were added

  case 3 if the interest is deleted and its created before the last 30 days
  and its last update was before the last 30 days:
  return 0 as there are no stories added within the last 30 days

  case 4 if the interest is not deleted and its created before the last 30 days:
  get all the stories within the creation of the interest until the current date
  and group by the date of creation.
  then get the count of the stories added to the interest per day and 0 
  if no stories were added

  case 5 if the interest is not deleted and its created within the last 30 days:
  get all the stories within interest creation date until the current date and
  group by the date of creation.
  then get the count of the stories added to the interest per day and 0 if 
  no stories were added
  '''
  ##########Author: Diab ############
  def self.get_num_stories_in_interest_day(interest_id)

  interest_create_date = Interest.find(interest_id).created_at
  interest_last_update_date = Interest.find(interest_id).updated_at 
  deleted = Interest.find(interest_id).deleted_before_type_cast 

  

  if deleted && interest_create_date >= 30.days.ago.to_date && 
     interest_last_update_date >= 30.days.ago.to_date

      stories_per_day = Story.where(:created_at => interest_create_date.beginning_of_day..
      interest_last_update_date.end_of_day , :interest_id => interest_id)
      .group("date(created_at)").select("created_at , count(id) as strys_day")

      (interest_create_date.to_date..interest_last_update_date.to_date).map do |date|
      story = stories_per_day.detect { |story| story.created_at.to_date == date}
      story && story.strys_day.to_i || 0
          end.inspect
  

  elsif deleted && interest_create_date < 30.days.ago.to_date && 
        interest_last_update_date >= 30.days.ago.to_date

         stories_per_day = Story.where(:created_at => 30.days.ago.beginning_of_day..
         interest_last_update_date.end_of_day , :interest_id => interest_id)
         .group("date(created_at)").select("created_at , count(id) as strys_day") 
  
         (30.days.ago.to_date..interest_last_update_date.to_date).map do |date|
         story = stories_per_day.detect { |story| story.created_at.to_date == date}
         story && story.strys_day.to_i || 0  
           end.inspect


  elsif deleted && interest_create_date < 30.days.ago.to_date && 
        interest_create_date < 30.days.ago.to_date
  
          stories_per_day = []  
  

  elsif interest_create_date < 30.days.ago.to_date

         stories_per_day = Story.where(:created_at => 30.days.ago.beginning_of_day..
         Time.zone.now.end_of_day , :interest_id => interest_id)
         .group("date(created_at)").select("created_at , count(id) as strys_day") 
  
         (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
         story = stories_per_day.detect { |story| story.created_at.to_date == date}
         story && story.strys_day.to_i || 0
     end.inspect

  else

    stories_per_day = Story.where(:created_at => interest_create_date.beginning_of_day..
    Time.zone.now.end_of_day , :interest_id => interest_id)
    .group("date(created_at)").select("created_at , count(id) as strys_day") 
    
    (interest_create_date.to_date..Time.zone.now.to_date).map do |date|
    story = stories_per_day.detect { |story| story.created_at.to_date == date}
    story && story.strys_day.to_i || 0
     end.inspect

  end
 end 

  '''this method when called will get the number of users who added an interest
  for each day.
  first to get when the interest was created
  then to get when the interest was updated last time
  then check if the interest is deleted or not
  
  the cases are
  
  case 1 if the interest is deleted and it is created within the last 30 day:
  but its last update was within the last 30 days
  get all the users within the creation and deletion of the interest and 
  group by the date of creation then get the count of the users added the 
  interest per day and 0 if no users added it
  
  case 2 if the interest is deleted and its created before the last 30 days:
  first get all the users within the last 30 days and the last update of the 
  interest and group by the date of creation.
  then get the count of the users added the interest per day and 0 if
  no users added it

  case 3 if the interest is deleted and its created before the last 30 days
  and its last update was before the last 30 days:
  return 0 as there are no users added the interest within the last 30 days

  case 4 if the interest is not deleted and its created before the last 30 days:
  get all the users within the creation of the interest until the current date
  and group by the date of creation.
  then get the count of the users added the interest per day and 0 
  if no user added it

  case 5 if the interest is not deleted and its created within the last 30 days:
  get all the users within interest creation date until the current date and
  group by the date of creation.
  then get the count of the users added the interest per day and 0 if 
  no user added it
  '''
  ##########Author: Diab ############
  def self.get_num_users_added_interest_day(interest_id)

    interest_create_date = Interest.find(interest_id).created_at 
    interest_last_update_date = Interest.find(interest_id).updated_at
    deleted = Interest.find(interest_id).deleted_before_type_cast 


  if deleted && interest_create_date >= 30.days.ago.to_date && 
     interest_last_update_date >= 30.days.ago.to_date
  
     users_per_day = UserAddInterest.where(:created_at => interest_create_date
     .beginning_of_day..interest_last_update_date.end_of_day , :interest_id => interest_id)
     .group("date(created_at)").select("created_at , count(user_id) as usrs_day")
 
     (interest_create_date.to_date..interest_last_update_date.to_date).map do |date|
     user = users_per_day.detect { |user| user.created_at.to_date == date}
     user && user.usrs_day.to_i || 0
       end.inspect
  

  elsif deleted && interest_create_date < 30.days.ago.to_date && 
        interest_last_update_date >= 30.days.ago.to_date
  
        users_per_day = UserAddInterest.where(:created_at => 30.days.ago.
        beginning_of_day..interest_last_update_date.end_of_day , :interest_id => interest_id)
        .group("date(created_at)").select("created_at , count(user_id) as usrs_day") 
        
        (30.days.ago.to_date..interest_last_update_date.to_date).map do |date|
        user = users_per_day.detect { |user| user.created_at.to_date == date}
        user && user.usrs_day.to_i || 0  
          end.inspect


  elsif deleted && interest_create_date < 30.days.ago.to_date && 
        interest_last_update_date < 30.days.ago.to_date
  
       users_per_day = []  
  

  elsif interest_create_date < 30.days.ago.to_date
  
      users_per_day = UserAddInterest.where(:created_at => 30.days.ago.beginning_of_day..
      Time.zone.now.end_of_day , :interest_id => interest_id)
      .group("date(created_at)").select("created_at , count(user_id) as usrs_day") 
  
      (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
      user = users_per_day.detect { |user| user.created_at.to_date == date}
      user && user.usrs_day.to_i || 0
        end.inspect

  else
 
      users_per_day = UserAddInterest.where(:created_at => interest_create_date.
      beginning_of_day..Time.zone.now.end_of_day , :interest_id => interest_id)
      .group("date(created_at)").select("created_at , count(user_id) as usrs_day") 
  
      (interest_create_date.to_date..Time.zone.now.to_date).map do |date|
      user = users_per_day.detect { |user| user.created_at.to_date == date}
      user && user.usrs_day.to_i || 0
        end.inspect
  end
 end

 '''these methods are to get all the general info regarding the statistics of 
    the interest from the database , given its id as a parameter

 #to get the count of the stories inside the given interest'''
 ##########Author: Diab ############
 def self.get_interest_num_stories(interestId) 

 num_stories_in_interest = Story.where(:interest_id => interestId).count
 
 end
 
 '''to get the count of the users who added this interest'''
 ##########Author: Diab ############
 def self.get_total_num_user_added_interest(interestId)

 num_users_added_interest = UserAddInterest.where(:interest_id => interestId).count 
 
 end

'''This is the method that should return the data of statistics of an interest
 with this format first element in the data arrays is ARRAY OF "No Of Users",
 second one is "No Of stories"'''
 ##########Author: Diab ############
 def self.get_interest_stat(interest_id)
 sto = get_num_stories_in_interest_day(interest_id)
 usr = get_num_users_added_interest_day(interest_id)
 data ="[#{usr} , #{sto}]"
 end

=begin 
    This method is to rank an interest according to the scheme we agreed on
    2 points for each story added to it and 5 points for each user who added 
    this interest 
    ##########Author: Diab ############
=end
    
 def get_interest_rank
 
  rank =  (self.stories.count * 2) + (self.adding_users.count * 5)

 end
 
 
=begin to get a list of hashes with all the interests and all of their ranks by 
 calling the method get_interest_rank on 3ach one of the interests in the system'''
 ##########Author: Diab ############
=end

 def self.rank_all_interests

   interests=[]

   Interest.all.each do |interest|

     interests<< {:rank => interest.get_interest_rank, :theinterest => interest}
  
   end

  ranked_interests =  interests

end
 
=begin this method returns a list of the top ranked interests in 
 a descending order (Higher Rank First)'''
 ##########Author: Diab ############
=end 
 def self.get_top_interests

    ranked_interests = rank_all_interests
    interests=[]

    (ranked_interests.sort_by {|element| element[:rank]}).each do |hsh|

      interests << hsh[:theinterest]
    
    end
    
    top_interests =  interests.reverse
 
 end

=begin this method returns a list of names of the top ranked interests in 
 a descending order (Higher Rank First)'''
 ##########Author: Diab ############
=end 
 def self.get_top_interests_names

    ranked_interests = rank_all_interests
    interests=[]

    (ranked_interests.sort_by {|element| element[:rank]}).each do |hsh|

      interests << hsh[:theinterest].name.to_s

    end

    top_interests_names =  interests.reverse
 
 end

=begin this method returns a list of ranks of the top ranked interests in 
 a descending order (Higher Rank First)'''
 ##########Author: Diab ############
=end 
 def self.get_top_interests_ranks

    ranked_interests = rank_all_interests
    interests=[]

    (ranked_interests.sort_by {|element| element[:rank]}).each do |hsh|

      interests << hsh[:rank]

    end

    top_interests_ranks = interests.reverse
 
 end
 
=begin to return a list of user who added this interest'''
 ##########Author: Diab ############
=end
def get_users_added_interest 

  users = self.adding_users 

end

def self.get_interest(id)
Interest.find(id)
end
=begin
#Author: jailan
Create Method after moving it from controller to Model descriptlion)
It makes a new interest and saves it
=end

  def self.model_create(interest)
    @interests = Interest.get_all_interests
    @interest = Interest.new(interest)
    @interest.save
    if @interest
      Log.create!(loggingtype: 1,user_id_1: nil,user_id_2: nil,admin_id: nil,story_id: nil,interest_id: @interest.id,message: "Admin added an interest")
    end 
    return @interest
  end
=begin
#Author: jailan
Update Method after moving it from controller to Model
takes as argument the id of the interest and the new values we want to update with and returns the interest after updating the deleted column in it
It gets the interest using the id and call the method Update_Attribute that takes the input in the form of "Show.html.erb" and adjust changes
=end
  def self.model_update(id,interest)
    @interest= Interest.find(id)
    @interests = Interest.all 
    @deleted = Interest.is_deleted(id)
    if (@deleted == false || @deleted.nil?) 
      @interest.save 
      if @interest
        Log.create!(loggingtype: 1,user_id_1: nil,user_id_2: nil,admin_id: nil,story_id: nil,interest_id: @interest.id,message: "Admin Updated an interest")
      end
      return   @interest.update_attributes(interest)           
    else
      return @interest
    end
  end
=begin
#Author: jailan
is_deleted Method 
takes the id of the interest and returns the value of deleted attribute to use it in the controller
=end
  def self.is_deleted(id)
    @interest = Interest.find(id)
    return @interest.deleted
  end

=begin
#Author: jailan
model_toggle method used to block/unblock the interest according to its state 
takes as argument the id of the interest and returns the interest after updating the deleted column in it
=end
  def self.model_toggle(id)
    @interest= Interest.find(id)
    @interests = Interest.all 
# if the interest was blocked the we restore it and save
    if @interest.deleted 
      @interest.deleted = nil
      @interest.save
      if @interest
        Log.create!(loggingtype: 1,user_id_1: nil,user_id_2: nil,admin_id: nil,story_id: nil,interest_id: @interest.id,message: "Admin Restored an interest")
      end
    else
# if the interest wasn't blocked the we block it and save
      @interest.deleted = true
      @interest.save
      if @interest
        Log.create!(loggingtype: 1,user_id_1: nil,user_id_2: nil,admin_id: nil,story_id: nil,interest_id: @interest.id,message: "Admin Blocked an interest")
      end
    end
    return @interest
  end

end

