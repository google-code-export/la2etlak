class InterestsController < ApplicationController
  before_filter {admin_authenticated?}
  def index
    redirect_to "/interests/list"
    @interests = Interest.all #passing a list of all interests to show them all in the view
  end

  def show
     
    @interests = Interest.get_all_interests
    @interest = Interest.get_interest(params[:id])
    @stories = Story.find_all_by_interest_id(params[:id]) # get
    @stories = @stories.sort_by { |obj| obj.created_at }.reverse
    @feeds = Feed.find_all_by_interest_id(params[:id])
    @feed = Feed.find_by_interest_id(params[:id])#retrieving the feeds for a certain interest in the database using the id of the interest

    if @feed == nil #if the list of RSS feeds if a certain interest is empty we will create a new one
       @feed = Feed.new
    end
    @title = @interest.name

  end


  def new
  $errors = false
  @interests = Interest.all 
  if @interests.empty?
      flash[:error] = "There are currently no interests. $red" 
  end
  @feed = Feed.new # creaing a new interest and returning it in a variable @interest used in the form in new.html.erb 
  @interest = Interest.new
  @title = "Add interest"
  end
=begin  


#Author : Jailan

" CREATE " is a method to create a new interest using if-else statements, which allows us to handle the cases of failure and success separately based on the value of @interest.save, if saving succeeds ( according to validations ) then we redirect to the main page of the interest 
 otherwise , we render once more  the "New" page 

this methods retrieves and adjust changes to the adtabase using "model_create" method in the Model

it class "my_create" method in the Model that takes Interest Parameters (name, description , Image)
and saves it , if it's saved then a success message appears .. otherwise an error message appears .

=end

  def create 
    $saved = nil
    $savedinterest
    @interests = Interest.get_all_interests
    @interest = Interest.model_create(params[:interest])
    if @interest.save
      flash[:success] = "Your Interest was added Successfully $green"
      Log.create!(loggingtype: 1,user_id_1: nil,user_id_2: nil,admin_id: nil,story_id: nil,interest_id: @interest.id,message: "Admin added an interest")
      redirect_to @interest
    else
      $errors = true
      @title = "Add Interest"     
      render 'new'
#Render 'new' , evaluates the contents in the error_messages partial contents, and insert the results into the view.
    end
  end

#Author: Jailan
#This part is to push Notifications to the admin
Admin.push_notifications "/admins/index" ,""


=begin
#Author : Jailan
Update Method uses the form in the view to update the attributes of the interest
all databese changes are done in the "model_update" method in the Model that takes as parameters the Interest's id as well as the Interests parameters to be changed (name , Image & Description)
=end

  def update
    @interests = Interest.get_all_interests
    @names = Interest.get_top_interests_names 
  
   @myinterest= Interest.get_interest(params[:id])
    #here, we call the method in model
    @interest= Interest.model_update(params[:id],params[:interest])
    @deleted = Interest.is_deleted(params[:id])
   
#we check on the interest deleted or not because an admin is not allowed to adjust any changes/edit an interest unless it's ACTIVE
    if @interest && (@deleted == false || @deleted.nil?)
      flash[:success] = " Changes saved successfully $green"
 
      redirect_to @myinterest

    else
      $errors = true
#global variable $errors used to handle the flash message in "Show.html.erb"
      if (@deleted == false || @deleted.nil?)  && (params[:interest][:name].blank?)
# a flash appears when we enter an invalid info (balnk name)          
        flash[:error] = "  Interest update failed: Name can't be blank $red"
      else
        if (@deleted == false || @deleted.nil?) && (@names.include?(params[:interest][:name])) && 
(params[:interest][:name] != @myinterest.name)
 # a flash appears when we enter a name that was taken for another Interest before 
          flash[:error] = " Interest already exists. Please try another name $red"


        else
         if (@deleted == false || @deleted.nil?) 
  # a flash appears when we enter an invalid info (invalid content type of image) 
          flash[:error] = " Interest Update failed, photo content type is invalid. $red"
        else
#a flash appears banning the admin from updating the interest as long as it's blocked
          flash[:error] = " This interest is now blocked, please restore it if you want to update $red"
        end
      end
      end
      @myinterest= Interest.get_interest(params[:id])
      redirect_to @myinterest
    end
#after updating we redirect to the interest main page but after editing

  end

=begin
#Author: jailan

Toggle method used to block/unblock the interest , when we block an interest no feeds appear for the users only the admin can view it 
if the interest is deleted then he admin has the right to restore it once more .

this method calls the "model_toggle" method that takes as parameters the Interest's id .
=end
  def toggle
    @interest= Interest.model_toggle(params[:id])
    @interests = Interest.get_all_interests
    @deleted = Interest.is_deleted(params[:id])
    if !@deleted 
      $savedinterest = true
# if the interest was deleted and the admin restored it successfully a flash appears endicating that
      flash[:success] = " Interest restored successfully $green"
    else
# if the interest wasn't deleted and the admin blocked it successfully a flash appears endicating that
      flash[:error] = " You have just blocked this interest $red"


    end
# finally , we redirect to the main interest's page after adjusting the changes
    redirect_to @interest
  end

end
      
