
class Emailer < ActionMailer::Base
  default from: "info.2allak@gmail.com"
  default_url_options[:host] = "localhost:3000"
	# Author: Kiro
	def verification_instructions(user)
		@code = user.verification_code.code
		mail(:to => user.email, :subject => "La2etlak Verification Instructions")
	end

	# Author: Kiro
  def resend_code(user)
  	@code = user.verification_code.code
  	mail(:to => user.email, :subject => "La2etlak Verification Code")
  end

	# Author: Kiro
  def reset_password(user,pass)
  	@pass = pass
  	mail(:to => user.email, :subject => "La2etlak New Password")
  end

  def password_reset(h_account, pass)
    @passw = pass
    mail(:to => h_account.email, :subject => "2allak New Password")
  end
  
=begin 
  Method Description: This method takes the user and the resetted password and puts it in 
  a variable to be used in show of the mail then it sends the mail to the user mail with 
  the subject and its view.
  Parameters (User object and generated password, void)
  Author : Gasser
=end
  def send_forced_password(user, pass)
    @passw = pass
    mail(:to => user.email, :subject => "Your Password was reset by the Admin")
  end
#Author: khaled
	def recommend_story(sender, reciever, message, stitle, surl)

	 @user=sender
	 @friend=reciever
	 @mess=message
	 @storytit=stitle
   @storyurl=surl

	mail(:to => @friend, :subject => "recommendation in La2etlak app")

	end

#Author: khaled
	def invite_to_app(sender, reciever, message, stitle, surl)

		 @user=sender
		 @friend=reciever
		 @mess=message
	   @storytit=stitle
     @storyurl=surl
		
		mail(:to => @friend, :subject => "invitation to La2etlak app")

	 end

	# Author: Mouaz
  def reset_admin_password(admin,pass)
  	@pass = pass
  	mail(:to => admin.email, :subject => "La2etlak New Password")
  end



# Author : Bassem
  def notify_deactivation(user)
    mail(:to => user.email, :subject => "Your La2etlak account has been deactivated")
  end

# Author : Bassem
  def notify_activation(user)
    mail(:to => user.email, :subject => "Your La2etlak account has been re-activated")
  end

	# Author: Mouaz
        #this method send reseting password message with the private password reset link
  def password_reset_instructions(admin)
    #subject       "Password Reset Instructions"
    #from          "Binary Logic Notifier <noreply@binarylogic.com>"
    #recipients    admin.email
    #sent_on       Time.now
    #body  = :edit_password_reset_url => edit_password_reset_url(admin.perishable_token)
    @edit_password_reset_url = edit_password_reset_url(admin.perishable_token)
mail(:to => admin.email, :subject => "Password Reset Instructions")
  end 
end
