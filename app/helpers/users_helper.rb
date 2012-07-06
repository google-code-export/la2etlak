module UsersHelper
  #This method when called will return the difference between today and the day the user registered in our app in days.
  def get_no_of_activity(needed_graph, creation_date, last_update, deactivated)

    if deactivated && creation_date >= 30.days.ago.to_date && 
       last_update >= 30.days.ago.to_date
      activities_by_day = needed_graph.where(:created_at => 
      creation_date..last_update).group("date(created_at)").select("created_at, 
      count(user_id) as noPerDay")
      (creation_date.to_date..last_update.to_date).map do |date|
        activity = activities_by_day.detect { |activity| 
        activity.created_at.to_date == date }
        activity && activity.noPerDay.to_i || 0
      end.inspect
      
    elsif deactivated && creation_date < 30.days.ago.to_date && 
          last_update >= 30.days.ago.to_date
      activities_by_day = needed_graph.where(:created_at => 
      30.days.ago.beginning_of_day..last_update).group(
      "date(created_at)").select("created_at, count(user_id) as noPerDay")
      (30.days.ago.to_date..last_update.to_date).map do |date|
        activity = activities_by_day.detect { |activity| 
        activity.created_at.to_date == date }
        activity && activity.noPerDay.to_i || 0
      end.inspect
      
    elsif deactivated && creation_date < 30.days.ago.to_date && 
          last_update < 30.days.ago.to_date
      activities_by_day = []
      
    elsif creation_date < 30.days.ago.to_date
      activities_by_day = needed_graph.where(:created_at => 30.days.ago.beginning_of_day..Time.zone.now.end_of_day).group(
      "date(created_at)").select("created_at, count(user_id) as noPerDay")
      (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
        activity = activities_by_day.detect { |activity| 
        activity.created_at.to_date == date }
        activity && activity.noPerDay.to_i || 0
     end.inspect
    else
    
      activities_by_day = needed_graph.where(
      :created_at => creation_date..Time.zone.now.end_of_day).group(
      "date(created_at)").select("created_at, count(user_id) as noPerDay")
      (creation_date.to_date..Time.zone.now.to_date).map do |date|
        activity = activities_by_day.detect { |activity| 
        activity.created_at.to_date == date }
        activity && activity.noPerDay.to_i || 0
      end.inspect
    end
  end


 def get_user_start_date(user_id)
   user_reg_date = User.find(user_id).created_at_before_type_cast.to_date
   last_updated = User.find(user_id).updated_at_before_type_cast.to_date
   deactivated = User.find(user_id).deactivated_before_type_cast
   if deactivated && user_reg_date > 30.days.ago.to_date && last_updated > 30.days.ago.to_date
     date = Time.zone.now.to_date - user_reg_date
   elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated > 30.days.ago.to_date
     date = Time.zone.now.to_date - 30.days.ago.to_date
   elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated <= 30.days.ago.to_date
     date = -1
   elsif user_reg_date <= 30.days.ago.to_date
     date = Time.zone.now.to_date - 30.days.ago.to_date
   else
     date = Time.zone.now.to_date - user_reg_date
   end
 end
 
#This method gets the number of Shares by this user in the last 30 days
 def get_no_of_shares_user(user_id)

   user_reg_date = User.find(user_id).created_at_before_type_cast.to_date
   last_updated = User.find(user_id).updated_at_before_type_cast.to_date
   deactivated = User.find(user_id).deactivated
   #1) If the user registered and was deactivated within the last 30 days
     if deactivated && user_reg_date > 30.days.ago.to_date
       shares_by_day = Share.where(:user_id => user_id, :created_at => user_reg_date..last_updated).group("date(created_at)").select("created_at, count(user_id) as noOfSharesPerDay")
       (user_reg_date.to_date..last_updated.to_date).map do |date|
         share = shares_by_day.detect { |share| share.created_at.to_date == date}
         share && share.noOfSharesPerDay.to_i || 0
       end.inspect
   #2) If the user registered before the last 30 days and was dactivated within the last 30 days
     elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated > 30.days.ago.to_date
       shares_by_day = Share.where(:created_at => 30.days.ago..last_updated, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfSharesPerDay")
	   (30.days.ago.to_date..last_updated.to_date).map do |date|
         share = shares_by_day.detect { |share| share.created_at.to_date == date }
         share && share.noOfSharesPerDay.to_i || 0
        end.inspect
   #3) If the user registered and deactivated before the last 30 days
	 elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated <= 30.days.ago.to_date
       shares_by_day = []
   #4) if the user registered before 30 days and wasn't deactivated
     elsif user_reg_date <= 30.days.ago.to_date
       shares_by_day = Share.where(:created_at => 30.days.ago..Time.zone.now.end_of_day, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfSharesPerDay")
       (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
         share = shares_by_day.detect { |share| share.created_at.to_date == date }
         share && share.noOfSharesPerDay.to_i || 0
       end.inspect
   #5) if the user registered within 30 days and wasn't deactivated
     else
       shares_by_day = Share.where(:created_at => user_reg_date.beginning_of_day..Time.zone.now.end_of_day, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfSharesPerDay")
       (user_reg_date.to_date..Time.zone.now.to_date).map do |date|
         share = shares_by_day.detect { |share| share.created_at.to_date == date }
         share && share.noOfSharesPerDay.to_i || 0
        end.inspect
      end
	end
	  
  #This method gets the number of Likes by this user in the last 30 days	  	  	
  def get_no_of_likes_user(user_id)

    user_reg_date = User.find(user_id).created_at_before_type_cast.to_date
    last_updated = User.find(user_id).updated_at_before_type_cast.to_date
    deactivated = User.find(user_id).deactivated
    #1) If the user registered and was deactivated within the last 30 days
    if deactivated && user_reg_date > 30.days.ago.to_date && last_updated > 30.days.ago.to_date
      likes_by_day = Likedislike.where(:created_at => user_reg_date..last_updated, :user_id => user_id, :action => 1).group("date(created_at)").select("created_at, count(user_id) as noOfLikesPerDay")
      (user_reg_date.to_date..last_updated.to_date).map do |date|
        like = likes_by_day.detect { |like| like.created_at.to_date == date }
        like && like.noOfLikesPerDay.to_i || 0
      end.inspect
    #2) If the user registered before the last 30 days and was dactivated within the last 30 days
    elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated > 30.days.ago.to_date
      likes_by_day = Likedislike.where(:created_at => 30.days.ago..last_updated, :user_id => user_id, :action => 1).group("date(created_at)").select("created_at, count(user_id) as noOfLikesPerDay")
      (30.days.ago.to_date..last_updated.to_date).map do |date|
        like = likes_by_day.detect { |like| like.created_at.to_date == date }
        like && like.noOfLikesPerDay.to_i || 0
       end.inspect
    #3) If the user registered and deactivated before the last 30 days
    elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated <= 30.days.ago.to_date
      likes_by_day = []
    #4) if the user registered before 30 days and wasn't deactivated
    elsif user_reg_date <= 30.days.ago.to_date
      likes_by_day = Likedislike.where(:created_at => 30.days.ago..Time.zone.now.end_of_day, :user_id => user_id, :action => 1).group("date(created_at)").select("created_at, count(user_id) as noOfLikesPerDay")
      (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
        like = likes_by_day.detect { |like| like.created_at.to_date == date }
        like && like.noOfLikesPerDay.to_i || 0
      end.inspect
    #5) if the user registered within 30 days and wasn't deactivated
    else
      likes_by_day = Likedislike.where(:created_at => user_reg_date.beginning_of_day..Time.zone.now.end_of_day, :user_id => user_id, :action => 1).group("date(created_at)").select("created_at, count(user_id) as noOfLikesPerDay")
      (user_reg_date.to_date..Time.zone.now.to_date).map do |date|
        like = likes_by_day.detect { |like| like.created_at.to_date == date }
        like && like.noOfLikesPerDay.to_i || 0
      end.inspect
    end
  end
  
#This method gets the number of Dislikes by this user in the last 30 days
  def get_no_of_dislikes_user(user_id)

    user_reg_date = User.find(user_id).created_at_before_type_cast.to_date
    last_updated = User.find(user_id).updated_at_before_type_cast.to_date
    deactivated = User.find(user_id).deactivated    
    #1) If the user registered and was deactivated within the last 30 days
    if deactivated && user_reg_date > 30.days.ago.to_date && last_updated > 30.days.ago.to_date
      dislikes_by_day = Likedislike.where(:created_at => user_reg_date..last_updated, :user_id => user_id, :action => -1).group("date(created_at)").select("created_at, count(user_id) as noOfDislikesPerDay")
      (user_reg_date.to_date..last_updated.to_date).map do |date|
        dislike = dislikes_by_day.detect { |dislike| dislike.created_at.to_date == date }
        dislike && like.noOfDislikesPerDay.to_i || 0
      end.inspect
    #2) If the user registered before the last 30 days and was dactivated within the last 30 days
    elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated > 30.days.ago.to_date
      dislikes_by_day = Likedislike.where(:created_at => 30.days.ago..last_updated, :user_id => user_id, :action => -1).group("date(created_at)").select("created_at, count(user_id) as noOfDislikesPerDay")
      (30.days.ago.to_date..last_updated.to_date).map do |date|
        dislike = dislikes_by_day.detect { |dislike| dislike.created_at.to_date == date }
        dislike && dislike.noOfDislikesPerDay.to_i || 0
      end.inspect
    #3) If the user registered and deactivated before the last 30 days
    elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated <= 30.days.ago.to_date
      dislikes_by_day = []
    #4) if the user registered before 30 days and wasn't deactivated
      elsif user_reg_date <= 30.days.ago.to_date
        dislikes_by_day = Likedislike.where(:created_at => 30.days.ago..Time.zone.now.end_of_day, :user_id => user_id, :action => -1).group("date(created_at)").select("created_at, count(user_id) as noOfDislikesPerDay")
        (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
          dislike = dislikes_by_day.detect { |dislike| dislike.created_at.to_date == date }
          dislike && dislike.noOfDislikesPerDay.to_i || 0
        end.inspect
    #5) if the user registered within 30 days and wasn't deactivated
      else
        dislikes_by_day = Likedislike.where(:created_at => user_reg_date.beginning_of_day..Time.zone.now.end_of_day, :user_id => user_id, :action => -1).group("date(created_at)").select("created_at, count(user_id) as noOfDislikesPerDay")
        (user_reg_date.to_date..Time.zone.now.to_date).map do |date|
          dislike = dislikes_by_day.detect { |dislike| dislike.created_at.to_date == date }
          dislike && dislike.noOfDislikesPerDay.to_i || 0
        end.inspect
      end
   end

#This method gets the number of Comments by this user in the last 30 days	  		
  def get_no_of_comments_user(user_id)

    user_reg_date = User.find(user_id).created_at_before_type_cast.to_date
    last_updated = User.find(user_id).updated_at_before_type_cast.to_date
    deactivated = User.find(user_id).deactivated
    #1) If the user registered and was deactivated within the last 30 days
    if deactivated && user_reg_date > 30.days.ago.to_date && last_updated > 30.days.ago.to_date
      comments_by_day = Comment.where(:created_at => user_reg_date..last_updated, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfCommentsPerDay")
      (user_reg_date.to_date..last_updated.to_date).map do |date|
        comment = comments_by_day.detect { |comment| comment.created_at.to_date == date }
        comment && comment.noOfcommentsPerDay.to_i || 0
      end.inspect
    #2) If the user registered before the last 30 days and was dactivated within the last 30 days
    elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated > 30.days.ago.to_date
      comments_by_day = Comment.where(:created_at => 30.days.ago..last_updated, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfCommentsPerDay")
      (30.days.ago.to_date..last_updated.to_date).map do |date|
        comment = comments_by_day.detect { |comment| comment.created_at.to_date == date }
        comment && comment.noOfCommentsPerDay.to_i || 0
      end.inspect
    #3) If the user registered and deactivated before the last 30 days
    elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated <= 30.days.ago.to_date
      comments_by_day = []
    #4) if the user registered before 30 days and wasn't deactivated
    elsif user_reg_date <= 30.days.ago.to_date
      comments_by_day = Comment.where(:created_at => 30.days.ago..Time.zone.now.end_of_day, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfCommentsPerDay")
      (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
        comment = comments_by_day.detect { |comment| comment.created_at.to_date == date }
        comment && comment.noOfCommentsPerDay.to_i || 0
      end.inspect
    #5) if the user registered within 30 days and wasn't deactivated
    else
      comments_by_day = Comment.where(:created_at => user_reg_date.beginning_of_day..Time.zone.now.end_of_day, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfCommentsPerDay")
      (user_reg_date.to_date..Time.zone.now.to_date).map do |date|
        comment = comments_by_day.detect { |comment| comment.created_at.to_date == date }
        comment && comment.noOfCommentsPerDay.to_i || 0
      end.inspect
    end
  end
	
  #This method gets the number of flags by this user in the last 30 days	  		
  def get_no_of_flags_user(user_id)
    user_reg_date = User.find(user_id).created_at_before_type_cast.to_date
    last_updated = User.find(user_id).updated_at_before_type_cast.to_date
    deactivated = User.find(user_id).deactivated
    #1) If the user registered and was deactivated within the last 30 days
    if deactivated && user_reg_date > 30.days.ago.to_date && last_updated > 30.days.ago.to_date
      flags_by_day = Flag.where(:created_at => user_reg_date..last_updated, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfFlagsPerDay")
      (user_reg_date.to_date..last_updated.to_date).map do |date|
        flag = flags_by_day.detect { |flag| flag.created_at.to_date == date }
        flag && flag.noOfFlagsPerDay.to_i || 0
      end.inspect
    #2) If the user registered before the last 30 days and was dactivated within the last 30 days
    elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated > 30.days.ago.to_date
      flags_by_day = Flag.where(:created_at => 30.days.ago..last_updated, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfFlagsPerDay")
      (30.days.ago.to_date..last_updated.to_date).map do |date|
        flag = flags_by_day.detect { |flag| flag.created_at.to_date == date }
        flag && flag.noOfFlagsPerDay.to_i || 0
      end.inspect
    #3) If the user registered and deactivated before the last 30 days
    elsif deactivated && user_reg_date <= 30.days.ago.to_date && last_updated <= 30.days.ago.to_date
      flags_by_day = []
    #4) if the user registered before 30 days and wasn't deactivated
    elsif user_reg_date <= 30.days.ago.to_date
      flags_by_day = Flag.where(:created_at => 30.days.ago..Time.zone.now.end_of_day, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfFlagsPerDay")
      (30.days.ago.to_date..Time.zone.now.to_date).map do |date|
        flag = flags_by_day.detect { |flag| flag.created_at.to_date == date }
        flag && flag.noOfFlagsPerDay.to_i || 0
      end.inspect
    #5) if the user registered within 30 days and wasn't deactivated
    else
      flags_by_day = Flag.where(:created_at => user_reg_date.beginning_of_day..Time.zone.now.end_of_day, :user_id => user_id).group("date(created_at)").select("created_at, count(user_id) as noOfFlagsPerDay")
      (user_reg_date.to_date..Time.zone.now.to_date).map do |date|
        flag = flags_by_day.detect { |flag| flag.created_at.to_date == date }
        flag && flag.noOfFlagsPerDay.to_i || 0
      end.inspect
    end
  end
end
