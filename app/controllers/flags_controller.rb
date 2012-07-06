class FlagsController < ApplicationController

   before_filter {user_authenticated?}

respond_to :html,:json
=begin
Description:this Action is called when a User Hits the Flag button in the Story view it calls the flag_story with the currently viewed story as parametar.
Input: sid - story id 
Output: nothing
Author:Kareem
=end

   def flag

				story_id = params[:sid]
  			story = Story.find(story_id)
  			user = current_user
  			result = user.flag_story(story)
				if(result == true)
						flash[:notice] = "Story flagged succesfully $green"
	 			 		redirect_to :controller => "stories", :action => "get" , :id => story_id
	  	  else
	  				flash[:notice] = "You already flagged this Story $red"
	 					redirect_to :controller => "stories", :action => "get" , :id => story_id 
				end

   end

end
