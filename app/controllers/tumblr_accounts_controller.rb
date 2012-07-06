class TumblrAccountsController < ApplicationController
  before_filter {user_authenticated?}
  require 'tumblr'
  
=begin
  renders the login form login.html.erb
  input: none
  output: email and password
  Author: Essam Hafez
=end
  def login 
    if(!current_user.tumblr_account.nil?)
      flash[:notice] = "You are already connected to tumblr. Enter tumblr email and password to update our records. $red"
    end
    render :layout => "mobile_template"
  end 
  
=begin
  creates the new tumblr account and relates it to the current user and saves the email and password the user entered
  then redirected back to social accounts page
  input: email and password
  output: none
  Author : Essam Hafez
=end
  def connect_tumblr
    email = params[:email]
    password = params[:password]
    if(email == "" or password == "")
      flash[:notice] = "Please enter a valid email and password $red"
      redirect_to action:'login' , controller:'tumblr_accounts'
    else
    test_tumblr = Tumblr::User.new(email, password)
    if(!test_tumblr.tumblr.nil?)
    tm = TumblrAccount.new
    tm.email = email
    tm.password = password
    tm.save
    current_user.tumblr_account = tm
    redirect_to action:'connect_social_accounts' , controller:'users'
  else
    flash[:notice] = "Email and password mismatch with tumblr, please try again $red"
    redirect_to action:'login' , controller:'tumblr_accounts'
  end
  end
  end
  
=begin
  deletes current user tumblr account
  input: noinput
  output: no output
  Author : Essam Hafez
=end
  def delete_account
    @user = current_user
    if @user.tumblr_account.destroy
      flash[:notice] = 'You are not connected to tumblr anymore $green'
    else 
      flash[:notice] = 'Something went wrong. Please try again $red'
    end 
    redirect_to controller: 'users', action: 'connect_social_accounts'
  end
end

