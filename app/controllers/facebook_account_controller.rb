class FacebookAccountController < ApplicationController

  before_filter {user_authenticated?}
=begin
   Action to be called from the connect_to_social network view
   which redirects to the facebook api using koala
   Inputs: none
   Output: none
   Author: Menisy
=end
  def authenticate_facebook_init
    path = Koala::Facebook::OAuth.new.url_for_oauth_code(:callback => "http://127.0.0.1:3000/fb/done/",:permissions => "read_stream")  
    redirect_to path
  end

=begin
 Action to be called in the call back url after authentication takes place
 If the authentication is successful a new Facebook account is created for the
 user 
 Input: None
 Output: 
 Author: Menisy
=end
  def authenticate_facebook_done
    if !params[:code]
      flash[:facebook_error] = "Facebook account was not added $red"
      redirect_to :controller => "users", :action => "feed"
      return
    end
    begin
    	token = Koala::Facebook::OAuth.new("http://127.0.0.1:3000/fb/done/").get_access_token(params[:code]) if params[:code]
    	fb_account = FacebookAccount.find_or_create_by_user_id(current_user.id)
    	fb_account.auth_token = token
    	fb_account.auth_secret = 1
    	graph =  Koala::Facebook::API.new(token)
    	user = graph.get_object("me")
    	fb_id = user["id"]
    	fb_account.facebook_id = fb_id
    	if fb_account.save
      	fb_account.add_to_log
      	flash[:facebook_connected] = "Facebook account connected. $green"
      	redirect_to :controller => "users", :action => "connect_social_accounts"
    	else
      	flash[:facebook_not_added] = "Facebook account was not added $red" + user.to_s
      	redirect_to :controller => "users", :action => "connect_social_accounts"
    	end
    rescue
    	flash[:facebook_error] = "Error occured contacting facebook $red" + user.to_s
      redirect_to :controller => "users", :action => "connect_social_accounts"
  	end
  end

=begin
  Action to delete the associated facebook account
  of a user. On success a flash message is shown which
  has an undo option.
  Inputs: none
  Output: none 
  Author: Menisy
=end
  def delete_account
    current_user.facebook_account.destroy
    message = "Facebook account disconnected, "
    flash[:facebook_account_deleted] = "#{message}<a href=\"/mob/facebook/auth_init\">
      <h7 style=\"color:#FF9408;\">undo?</h7> </a> $yellow"
    redirect_to :controller => "users", :action => "connect_social_accounts"
  end
end


