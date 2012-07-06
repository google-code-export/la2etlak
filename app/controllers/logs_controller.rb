class LogsController < ApplicationController
 before_filter {admin_authenticated?}
 
 #index called when when we want to see all logs
 #or refreshing the view from any filtering 
 #as you can see there is only one acess to the database
 
 #show all
 
  def index
       Log.get_All_Logs
        begin
         respond_to do |format|
            format.html { render :template => 'logs/Logs' }
            format.xls { send_data $logs.to_xls, content_type: 'application/vnd.ms-excel', filename: 'LogFile.xls' }
          end
        rescue
          render :template => 'shared/error_page'
        end
      end
 #used by a post http request to enter new logs into the database
 #from outside of the server

 #insertion
  
  def create
      if Log.add_New(params[:log])
          render :nothing => true 
          else
          render :nothing => true 
      end
  end
 #used to set attributes from the filtring
 #the real filter is happening in the view  
 
 #Filter
 
  def filter
    $admins = params[:admins]
    $users = params[:users]
    $stories = params[:stories]
    $interests = params[:interests]
    $typefilter = true
     render :template => 'logs/Logs'
  end
  #used to set attributes from the filtring
  #the real filter is happening in the view
  
 #Period selection 
 
  def filter_by_date
     if(params[:from]==''&&params[:to]=='')
        render :template => 'logs/Logs'
        @emptydata = true
        return
      end
    if(params[:from]==''||params[:to]=='')
       flash[:error] = "Missing an input ! $red"
      redirect_to logs_path
      return
    end
    if(!params[:from].match('(19|20)[0-9]{2}[- \/.](0[1-9]|1[012])[- \/.](0[1-9]|[12][0-9]|3[01])'))
      flash[:error] = "Wrong Format ! $red"
       redirect_to logs_path
       return
     end
      begin
     if( Date.parse(params[:from])> Date.parse(params[:to]))
       flash[:error] = "The limits of  your dates are wrong ! $red"
       redirect_to logs_path
       return
     end
       $typefilter = true
       $from_date = Date.parse(params[:from])
       $to_date = Date.parse(params[:to])
       #$logs =  Log.find(:all,:conditions=>['date(created_at) >= ? AND date(created_at) <= ?', $from_date,$to_date], :order => "created_at DESC")
        $datefilter = true
        render :template => 'logs/Logs'
     rescue 
        flash[:error] = "Invalid input ! $red"
        redirect_to(:action => 'index')
     end  
  end
 
 
 end
