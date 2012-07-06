class PasswordResetsController < ApplicationController
before_filter :load_admin_using_perishable_token, :only => [:edit, :update]  
  #before_filter :require_no_admin

def new  
    render layout: "login_template", template: "password_resets/new"  
end  
=begin
this method take the email and send the link to reset password
Author: Mouaz
Arguments : Admin.email
=end 
def create  
 @admin = Admin.find_by_email(params[:email])  
 if @admin  
  @admin.deliver_password_reset_instructions!
  Emailer.password_reset_instructions(@admin).deliver
  flash[:notice] = "Instructions to reset your password have been emailed to you. " +  
  "Please check your email."  
  redirect_to('/admin/login')  
 else  
  flash[:notice] = "No admin was found with that email address"  
  render :action => :new  
 end  
end
    

  
def edit  
    render layout: "login_template", template: "password_resets/edit"  
end  
=begin
this method resets password
Author: Mouaz
Arguments : Admin.password and Admin.password_confirmation
=end 
def update  
 @admin.password = params[:admin][:password]  
 @admin.password_confirmation = params[:admin][:password_confirmation]  
 if @admin.save  
  flash[:notice] = "Password successfully updated. $green"  
  redirect_to('/admin/logout')  

 else  
  flash[:notice] = "write your password correctly. $red"  
 end  
end  

=begin
 this private method is generating new perishable_token for the admin
 Author : Mouaz
 Arguments : Admin.id
=end
private  
def load_admin_using_perishable_token  
 @admin = Admin.find_using_perishable_token(params[:id])  
 unless @admin  
  flash[:notice] = "We're sorry, but we could not locate your account. " +  
  "If you are having issues try copying and pasting the URL " +  
  "from your email into your browser or restarting the " +  
  "reset password process."  
  #redirect_to('/admin/login')  
 end  
end
  
end
