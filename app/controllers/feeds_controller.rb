class FeedsController < ApplicationController
  before_filter {admin_authenticated?}
def index
   
end
def show
   redirect_to :controller => 'interests', :action => 'show', :id => @interest_id
end
def update
end

def new 
  @feed = Feed.new
end
=begin
  Method Description: Here I find the feed by the link given from the form and check if it is 
  present in the database or not and if it is present I give him an error message to tell him
  that he can not add the same RSS Feed for more than 1 interest.
  Author: Gasser
=end 
 def create
    #@id1 = Feed.find(params[:id]).interest_id
    $saved
    $savedinterest = false

    feed = Feed.find_by_link(params[:feed][:link]) 
    @feed= Feed.new(params[:feed]) #retrieving the feed from the database using the table feed parameters
    @interestid= params[:feed][:interest_id] 
    if feed.nil?    
      if params.has_key?(:feed) and StoriesHelper.check_rss(params[:feed][:link])
        if @feed.save
          redirect_to :controller => 'interests', :action => 'show', :id => @interestid
          flash[:feed_added] = "Link added successfully. $green"
          StoriesHelper.fetch_rss(params[:feed][:link])
          Log.create(loggingtype:3, interest_id:@interestid, message:"A new RSS link is added.")
        else #if saving faild a flash message box will appear with the errors
        flash[:invalid_link] = "Link is invalid. Please try again" 
        redirect_to :controller => 'interests', :action => 'show', :id => @interestid
       end 
     end
    else 
      flash[:same_rss_feed] = "Sorry, you cannot add the same RSS feed more than once. $red"
      redirect_to :controller => 'interests', :action => 'show', :id => @interestid
    end
end

  def destroy
        @id = Feed.find(params[:id]).interest_id
	Feed.find(params[:id]).destroy
	redirect_to :controller=>'interests', :action => 'show', :id => @id
        Log.create(loggingtype:3, interest_id:@interestid, message:"A new RSS link is deleted.")
  end


end

