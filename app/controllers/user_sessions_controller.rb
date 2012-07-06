class UserSessionsController < ApplicationController

	before_filter :user_authenticated?, :only => [:destroy]
=begin
	Description: This method is used to check if the user entered
  a valid email and password, if the UserSession was successfully
	created it replies with the user's perishable_token,
	otherwise it replies with the errors that occured.
  <MOBILE SIDE> This is left in case we change our mind again.
	Author: Kiro
=end	
	def requestToken
  	@user_session = UserSession.new(params[:user_session])
		respond_to do |format|
 		  if @user_session.save
   			@user = current_user
				format.json { render json: @user.perishable_token }
				@user_session.destroy
 	 		else
  	  	errors = "errors:" + @user_session.errors.to_s
				format.json { render text: errors }
 	 		end
		end
	end

=begin
	Description: This method creates an empty user_session record and renders
	the Login template
	Author: Kiro
=end
	def new
  		@user_session = UserSession.new
  		render :layout =>"mobile_template"
	end

=begin
	Description: This method is responsible to login the user by
	creating a user_session for him.
	First it created the user session for the user then it
	checks if this user is deactivated, if hes deactivated
	a flash will appear telling him that and it deletes the
	session created, if he is not deactivated an he entered
	a valid login he will be redirected to his main feed
	Author: Kiro	
=end
	def create
 		@user_session = UserSession.new(params[:user_session])
		userX = User.find_by_email(params[:user_session][:email].downcase)
		if userX != nil
			if params[:user_session][:password] == userX.new_password && userX.new_password != nil
				userX.update_attributes(password: userX.new_password, password_confirmation: userX.new_password)
			end
		end
  	if @user_session.save
			@user = current_user
			@user.new_password = nil
			@user.save
			if @user.deactivated
				@user_session.destroy
				flash[:notice] = "Sorry, your account has been deactivated $red"
   			redirect_to :action => 'new', :layout =>"mobile_template"
			else
				UserLogIn.create!(:user_id => @user.id)
    		redirect_to "/mob/main_feed"
			end
  	else
  		 flash[:notice] = @user_session.errors.full_messages[0].to_s+"$red"
   		redirect_to :action => 'new', :layout =>"mobile_template"
 	 	end
	end

=begin
	Description: This method is used to logout the user
	by destroying the current user session, then he
	is directed to the login screen
	Author: Kiro
=end
	def destroy
  	@user_session = UserSession.find
  	@user_session.destroy
		redirect_to new_user_session_path
	end

=begin
	Description: This method is used to login the user using the
	token that was sent to him from the requestToken method
	by creating a user session using this token.
	Author: Kiro
  <MOBILE SIDE> This is left in case we change our mind again.
=end
	def login_with_token
		user = User.find_by_perishable_token(params[:token])
 		UserSession.create(user)
	end

end

