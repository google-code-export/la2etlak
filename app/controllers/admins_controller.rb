class AdminsController < ApplicationController

    before_filter {admin_authenticated?}

  def search
    if params[:autocomplete][:query].length > 0
      $search_result = Admin.search(params[:autocomplete][:query])

      $users = $search_result[0]
      $stories = $search_result[1]
      $interests = $search_result[2]
      
      if $users.length == 0 and $stories.length == 0 and $interests.length == 0
        @message = "There are no matching results."
      end
    else
        @message = "Please enter query into the search bar."
    end
    
    respond_to do |format|
      format.html #index.html.erb
      format.json { render json: $users }
    end
  end
  
=begin
  This method checks the params of type passed from the search page so that
  it sets the @results variable to be either all results of the users or all 
  results of the stories or all results of the interests and it also applies
  the pagination method to @results.
  Author: Lydia
=end
  def all_results
    if params[:type] == "1"
    	if $users.length > 10
      	@results = $users.paginate(:page=>params[:page], :per_page=> 10)
      elsif
      	@results = $users
      end
    end
    if params[:type] == "2"
      if $stories.length > 10
      	@results = $stories.paginate(:page=>params[:page], :per_page=> 10)
      elsif
      	@results = $stories
      end
    end
    if params[:type] == "3"
      if $interests.length > 10
      	@results = $interests.paginate(:page=>params[:page], :per_page=> 10)
      elsif
      	@results = $interests
      end
    end
  end
 #Author : Mouaz
 
  def new
  @admin = Admin.new
  end
=begin
 this method for create new admin 
 if there is an attribute invalid user will be notified
 Author Mouaz
 param(admin parameters)
=end
  def create
    @admin = Admin.new(params[:admin])
    if @admin.save
      flash[:success] = "Addition successful."
      redirect_to('/admin_settings')
    else
      flash[:error] = "Enter Valid arguments. $red"
      redirect_to('/admin_settings')
    end
  end
=begin
  Get the admin mainpage with feed or redirect to login in case of there is no current admin
  Author: MESAI
=end
  def index
    @admin_session = AdminSession.find
    if current_admin == nil
     redirect_to('/admin/login')
    else
      Admin.get_feed
    end
  end
 #this method for reseting password
  def resetPassword
    @admin = Admin.find_by_email(params[:email])
    if @admin.nil?
      flash[:notice] ="This email doesn't exist red"
      redirect_to('/password_resets/new')
    else
		  newpass = @admin.resetPassword
		  Emailer.reset_admin_password(@admin,newpass).deliver
      flash[:notice] = "Your new password has been sent to your email green"
      redirect_to('/admin/login')
    end
  end
  def forgot_password
  @email
  redirect_to('admins/forgot_password.html.erb')
  end

  def edit
    @admin = current_admin
  end
=begin
 this method for edit current admin 
 if there is an attribute invalid user will be notified
 Author Mouaz
 param(admin parameters)
=end 
  def update
    @admin = current_admin
    if @admin.update_attributes(params[:admin])
      flash[:notice] = "Successfully updated profile. $green"
      redirect_to('/admin_settings')
    else
      flash[:error] = "Enter Valid arguments. $red"
      redirect_to('/admin_settings')
    end
  end
end
