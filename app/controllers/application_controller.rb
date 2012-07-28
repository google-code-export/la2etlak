class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :admin_authenticated?
  helper_method :user_authenticated?
	helper_method :current_user
  helper_method :current_admin
  helper_method :nokia_user?
  helper_method :user_verified?
  
    def nokia_user?
      return true
    	agent = request.env["HTTP_USER_AGENT"].downcase
    	if agent.index('nokia'.downcase)
    		return true
    	else
    		return false
    	end
    end

  def admin_authenticated?
    if(current_admin.nil?)
      redirect_to('/admin/login')
    return false
      else 
    return true
    end
  end

  def user_authenticated?
    unless nokia_user?
      return render text: 'This app is for Nokia users only.'
    end 
    if(current_user.nil?)
      redirect_to new_user_session_path
      return false
    else
      return true
    end
  end

	# This is a helper method that returns the User record
	# for the currently logged in user, this method is
  # added in the application controller since it is
	# needed to be accessed from anywhere inside the
	# application.
	# Author: Kiro
	private
	def current_user_session
 	 return @current_user_session if defined?(@current_user_session)
 	 @current_user_session = UserSession.find
	end

	def current_user
 	 @current_user = current_user_session && current_user_session.record
	end

	private
	def current_admin_session
 	 return @current_admin_session if defined?(@current_admin_session)
 	 @current_admin_session = AdminSession.find
	end

	def current_admin
 	 @current_admin = current_admin_session && current_admin_session.record
	end
           def require_admin 
     unless current_admin 
       store_location 
       flash[:notice] = "You must be logged in to access this page" 
       redirect_to('admin/login') 
       return false 
     end 
   end 
   def require_no_admin 
     if current_admin 
       store_location 
       flash[:notice] = "You must be logged out to access this page" 
       redirect_to('admin/login') 
       return false 
     end 
   end  
           
  def user_verified?
    puts (current_user.created_at + 10.days)
      puts Time.zone.now
    if current_user.verification_code.verified
      return true
    elsif current_user.created_at + 10.days < Time.zone.now
      flash[:notice] ="Sorry, but in order to continue using La2etlak you must verify your account first $red"
      redirect_to(:controller => 'users', :action => 'verifySettings')
      return false
    else
      puts (current_user.created_at + 10.days)
      puts Time.zone.now
      return true
    end
  end

end
