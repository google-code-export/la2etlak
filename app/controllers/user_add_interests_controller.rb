class UserAddInterestsController < ApplicationController

  before_filter {user_authenticated?}

#this Action calls the method get_interests and gets the interests of the current logged in User
#@user current Logged in user
#@interests List of user Interests names

 
	def get_interests
		
		@user = current_user
		@interests = @user.get_interests
  		render :layout => "mobile_template"
 #respond_to do |format|
   #format.html # index.html.erb
      #format.json { render json: @interests }

	#end
	end

end
