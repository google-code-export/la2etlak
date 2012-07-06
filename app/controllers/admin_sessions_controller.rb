class AdminSessionsController < ApplicationController

 def new  
    @admin_session = AdminSession.find
    if current_admin == nil
   @admin_session = AdminSession.new
    render layout: "login_template", template: "admin_sessions/new"  
    else
    redirect_to('/admins/index')  
    end
 end
=begin
  This method is used to check if the user entered a valid
 email and password, if the AdminSession was successfully
 created it replies with the user's perishable_token,
 otherwise it replies with the errors that occured.
 Author : mouaz
 params(admin_session parameters)
=end
 def create  
  @admin_session = AdminSession.new(params[:admin_session])  
  if @admin_session.save   
    redirect_to('/admins/index')  
  else  
    render layout: "login_template", template: "admin_sessions/new"  
  end  
 end  
=begin
 This method is used to logout the currently logged in
 admin by destroying his AdminSession
 otherwise it replies with the errors that occured.
 Author : mouaz
 params(admin_session parameters)
=end

 def destroy  
    @admin_session = AdminSession.find
  if @admin_session == nil
    redirect_to('/admin/login')
  else  
    @admin_session.destroy   
    redirect_to('/admin/login')
  end  
 end 
 

end
