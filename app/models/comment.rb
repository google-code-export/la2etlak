class Comment < ActiveRecord::Base
  
=begin
    
  This class is done solely by me, Menisy


=end


  attr_accessible :content
  belongs_to :user
  belongs_to :story
  has_many :comment_up_downs
  validates_presence_of :content
  validates_presence_of :user
  validates_presence_of :story
  
=begin
 This method adds the details of this comment to the log file.
 It will be called after a successful creation of the comment
  Inputs: none
  Output: none
  Author: Menisy
=end
  def add_to_log
    user_name = self.user.name  ||  self.user.email.split('@')[0]
    Log.create!(loggingtype: 2,user_id_1: self.user.id ,user_id_2: nil,admin_id: nil,story_id: self.story.id ,interest_id: nil,message: (user_name+" commented on \"" + self.story.title + "\" with \"" + self.content + "\"").to_s )
    Admin.push_notifications "/admins/index" ,""
  end
  
=begin
  This method checks if a user thumbed up this comment before
  Inputs: user who we want to check if he upped or not.
  Output: boolean true or false
  Author: Menisy
=end  
  def upped_by_user?(user)
    up = self.comment_up_downs.find_by_user_id_and_action(user.id,1) # get the up that a user gave to this comment before "if exists"
    !up.nil? # if up is nil then return false if not then return true
  end
  
=begin
  This method checks if a user thumbed down this comment before
  Inputs: user who we want to check if he upped or not.
  Output: boolean true or false
  Author: Menisy
=end  
  def downed_by_user?(user)
    down = self.comment_up_downs.find_by_user_id_and_action(user.id,2) # get the down that a user gave to this comment before "if exists"
    !down.nil? # if down is nil then return false if not then return true
  end

=begin
  Returns number of ups for a comment
  Inputs: none
  Output: int number of ups
  Author: Menisy
=end  
  def get_num_ups
    ups = self.comment_up_downs.find_all_by_action(1).size
  end

=begin
  Returns number of downs for a comment
  Inputs: none
  Output: int number of downs
  Author: Menisy
=end  
  def get_num_downs
    downs = self.comment_up_downs.find_all_by_action(2).size
  end
  
=begin
  Ups a comment.
  Input: user who is upping the comment.
  Output: boolean indicating success or failure
  Author: Menisy
=end
  def up_comment(user)
    upped_before = self.upped_by_user?(user)
    downed_before = self.downed_by_user?(user)
    if !upped_before && !downed_before then #if user never upped or downed the comment then up it
      up = CommentUpDown.new(:action => 1)
      up.comment = self
      up.user = user
      up.save
      up.add_to_log(self.user)
      #Author: Omar
      #adding the notification to the database for liking a comment 
      if user != self.user
    UserNotification.create(owner:self.user_id , user:user.id, story:self.story_id , comment:self.id , notify_type:5 , new:true)
    self.user.notifications =  self.user.notifications.to_i + 1
    self.user.save
      end
    #############################
      return true
    elsif downed_before then
      self.comment_up_downs.find_by_user_id_and_action(user.id,2).destroy #if user disliked it, now make him like it!
      up = CommentUpDown.new(:action => 1)
      up.comment = self
      up.user = user
      up.save
      up.add_to_log(self.user)
      #Author: Omar
      #adding the notification to the database for liking a comment 
      if comment.user != self.user
        UserNotification.create(owner:self.user_id , user:user.id, story:self.story_id , comment:self.id , notify_type:5 , new:true)
        self.user.notifications =  self.user.notifications.to_i + 1
        self.user.save
      end
    #############################
      return true
    elsif upped_before
      old_up = self.comment_up_downs.find_by_user_id_and_action(user.id,1) # if upped before, then un-up
      old_up.add_to_log(self.user,2)
      old_up.destroy
      return true
    else
      return false
    end     
  end
  
=begin
  Downs a comment.
  Input: user who is downing the comment.
  Output: boolean indicating success or failure
  Author: Menisy
=end
  def down_comment(user)
    upped_before = self.upped_by_user?(user)
    downed_before = self.downed_by_user?(user)
    if !upped_before && !downed_before then #if user never upped or downed the comment then up it
      down = CommentUpDown.new(:action => 2)
      down.comment = self
      down.user = user
      down.save
      down.add_to_log(self.user)
      #Author: Omar
      #adding the notification to the database for disliking a comment 
      if comment.user != self.user
       UserNotification.create(owner:self.user_id , user:user.id, story:self.story_id , comment:self.id , notify_type:6 , new:true)
       self.user.notifications =  self.user.notifications.to_i + 1
       self.user.save
      end
    ###################################
      return true
    elsif upped_before then
      self.comment_up_downs.find_by_user_id_and_action(user.id,1).destroy #if user disliked it, now make him like it!
      down = CommentUpDown.new(:action => 2)
      down.comment = self
      down.user = user
      down.save
      down.add_to_log(self.user)
      #Author: Omar
      #adding the notification to the database for disliking a comment 
      if user != self.user
       UserNotification.create(owner:self.user_id , user:user.id, story:self.story_id , comment:self.id , notify_type:6 , new:true)
       self.user.notifications =  self.user.notifications.to_i + 1
       self.user.save
      end
    ###################################
      return true
    elsif downed_before
      old_down = self.comment_up_downs.find_by_user_id_and_action(user.id,2) #if downed before then un-down
      old_down.add_to_log(self.user,2)
      old_down.destroy
      return true
    else
      return false
    end
  end

  def delete_comment
    self.deleted = true
    self.save
    
    #Ranking : Diab#
    s = self.story
    u = self.user
    s.rank = s.rank - 2
    u.rank = u.rank - 3
    s.save
    u.save
    #Ranking : Diab#

  end   

=begin
  Description: This story is mainly used in the notification system to summarize the
               content of the comment to fit within a certain length
        input: char_num:Int  which is the number of chars it will be summarized to
       output: String -> The summarized String
       Author: Kiro
=end  
  def summarize_content (char_num)
    if self.content.length <= char_num
      return self.content
    else return self.content[0..(char_num-1)] + "..."
    end
  end

end
