class Notifier < ActionMailer::Base  
  default from: "info.La2etlak@gmail.com"
  default_url_options[:host] = "localhost.com:3000"

  
  def password_reset_instructions(admin)
    #subject       "Password Reset Instructions"
    #from          "Binary Logic Notifier <noreply@binarylogic.com>"
    #recipients    admin.email
    #sent_on       Time.now
    #body  = :edit_password_reset_url => edit_password_reset_url(admin.perishable_token)
    @edit_password_reset_url = edit_password_reset_url(admin.perishable_token)
mail(:to => admin.email, :subject => "Password Reset Instructions", :edit_password_reset_url => @edit_password_reset_url, :body => @edit_password_reset_url)
  end  

end  
