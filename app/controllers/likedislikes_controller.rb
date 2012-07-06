class LikedislikesController < ApplicationController

  before_filter {user_authenticated?}
respond_to :html,:json

=begin
Description:this Action is called when the User Hits the Thumb up/down button in the Story View  and calls the thumb_story action with the Story or the Action user made.
Input: sid - story_id , act - action
Output:Nothing
Author:Kareem
=end


def thumb
	action = params[:act]
	action = action.to_i  
	story_id = params[:sid]
	user = current_user
	story = Story.find(story_id)
	user.thumb_story(story,action)
 	#redirects to the story View After doing the thumb up/down 
        redirect_to :controller => "stories", :action => "get" , :id => story_id 

  end
end 



