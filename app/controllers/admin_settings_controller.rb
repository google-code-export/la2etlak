class AdminSettingsController < ApplicationController

    before_filter {admin_authenticated?} 
=begin
This method initailizes the index page and gives it the admins to be created or updated
Inputs: @admin, @admin2
Outputs: non
Author: Bassem
=end
  	def index
  		@admin = Admin.new
      @admin2 = current_admin
  	end	
=begin	
	Method Description: A method in the admin_settings controller passed 
	from the settings page this function just calls the 
	static method in the model and passes the value entered in the form 
	then it redirects to the settings page again and it handles if the 
	admin enters characters not numbers in the text field and throws error
	and success flashes.
	Author : Gasser
=end
	def configure_flags_threshold
		input = params[:valuee].to_i
		if input == 0
			flash[:not_entering_numbers] = "Please enter a valid number. $red"
			redirect_to '/admin_settings'
			return
		else
			Admin_Settings.configure_flags_threshold input
			flash[:changed_settings] = "Settings Changed Successfully $green"
		end
		redirect_to '/admin_settings'
	end
=begin
	Method Decription: A method in the admin_settings controller passed
	from the settings page and calls the static method in the model to 
	update the value in the database and renders success flash that 
	the settings has changed.
	Author : Gasser
=end
	def configure_auto_hiding
		Admin_Settings.configure_auto_hiding	
		flash[:changed_settings] = "Settings Changed Successfully $green"
		redirect_to '/admin_settings'
	end 
	
 	def new
	  @admin = Admin.new
	end
	 #this method for create new admin 
	 #if there is an attribute invalid user will be notified
	  def create
	    @admin = Admin.new(params[:admin])
	    if @admin.save
	      flash[:notice] = "Addition successful."
	      redirect_to('/admin_settings')
	    else
   			
	      render :action => 'index'
	      flash[:error] = "Enter Valid Arguments."
	      redirect_to('/admin_settings')
	    end
	  end
=begin
This methods takes the number of days and passes it to the method in the model
Inputs: no of days
Outputs: non
Author: Bassem
=end
	  def statistics_time_span
	  	@response = Admin_Settings.set_statistics_span params[:days]
	  	if ( @response == 1 )
	  		flash[:span_set] = "Time span set successfully. $green"
	 	 else
	 	 	flash[:span_not_set] = "Please enter a valid number. $red"
	 	 end
	 	 	
	  	redirect_to :action => "index"
	  end
  def edit
    
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
      flash[:notice] = "Successfully updated profile."
        redirect_to('/admin_settings')
    else
      flash[:error] = "Enter Valid Arguments."
      redirect_to('/admin_settings')
    end
  end
end
