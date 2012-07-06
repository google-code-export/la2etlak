class StatisticsController < ApplicationController
 before_filter {admin_authenticated?}
 respond_to :js, :html
 def index
   @interests= Interest.all
 end
 def interests
   @id=params[:id]
   @interest=Interest.find(@id)
 end
 
 def stories
   @id=params[:id]
   @story= Story.find(@id)
 end
 
 def users
   @id=params[:id]
   @user=User.find(@id)
 end
 
 def all_users
  respond_with(@users = User.get_users_ranking)
 end
 def all_stories
  respond_with(@stories = Story.get_stories_ranking_all_time, @stories2 = Story.get_stories_ranking_last_30_days)
 end
 def all_interests
 end
end
