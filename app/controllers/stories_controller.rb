# encoding: utf-8
class StoriesController < ApplicationController

  before_filter :admin_authenticated?, :only => [:show, :index, :new, :create, :destroy, :filter]
  before_filter :user_authenticated?, :except => [:show, :index, :new, :create, :destroy, :filter]

  respond_to :html,:json
  require 'net/smtp'
  $hidden = true
  $flagged = true
  $active = true

def show
   @comments = Comment.find_all_by_story_id(params[:id]) # get comments of this story
   @story = Story.find(params[:id])

  end
  
  
  
=begin 
Discription : this method takes a story object as a parameter form social feed and renders its view 
Author : Omar
=end

  def get_story_feed
   @ser = params[:serStor]
   @story = Marshal::load(@ser)
   render :layout => "mobile_template"   
  end

=begin  
Discription :  this method taks params story id and get number of likes dislikes done by users and 
  renders mobile_template view , likes => method in the model gets the user who thumbed up story 
   dislikes=> method in model gets user who thumbed down the story
Author: Omar 
=end
  
   def get
	id = params[:id]
	@user = current_user
	@story = Story.find(id)
	@likes = @story.liked
	@dislikes = @story.disliked
	@action1 = @story.check_like(@user)
	@action2 = @story.check_dislike(@user)
	all_related_stories = @story.get_related_stories
	if(all_related_stories.length > 0)
	  @block = true
	 else 
	      @block = false
	 end
	filter_related_stories = all_related_stories - @user.blocked_stories
	 if (filter_related_stories.length < 5)
	 	filter_related_stories = filter_related_stories[0,filter_related_stories.length]
	 else
	 	filter_related_stories = filter_related_stories[0,5]
	 end
	 @filtered_related_stories = filter_related_stories	  
	 	
	#where(:interest_id => @story.interest.id) 
	#- @user.blockd_stories
  
  # instance variables for comments
  # Author: Menisy
  @story = Story.find(params[:id])
  @comment = Comment.new
  @user = current_user
  ### end of comment variables ###
	render :layout => "mobile_template"
  #render :temple => "show_comments"
  end

=begin  
  Renders the mobile view and initialize
  the instance variables needed for the 
  story page, this was used for seperate
  testing.
  ## DEPRECATED ###
  Author: Menisy
=end
  def mobile_show
    @story = Story.find(params[:id])
    @comment = Comment.new
    @user = current_user
    render :layout => "mobile_template" 
  end

=begin
  Action for thumbing up a comment with params passed in POST HTTP request
  Author: Menisy
=end  
  def up_comment
    comment = Comment.find(params[:comment_id])
    upped = comment.up_comment(current_user)
    if upped 
      redirect_to :action => "get" ,:id => params[:id]
    else
      flash[:notice] = "Temporary error has occured $red"
      redirect_to :action => "get" ,:id => params[:id]
    end
  end
=begin
  Action for thumbing down a comment with params passed in POST HTTP request
  Author: Menisy
=end
  def down_comment
    comment = Comment.find(params[:comment_id])
    downed = comment.down_comment(current_user)
    if downed 
      redirect_to :action => "get" ,:id => params[:id]
    else
      flash[:notice] = "Temporary error has occured $red"
      redirect_to :action => "get" ,:id => params[:id]
    end
  end


  def index
    @interests = Interest.all   
    @stories = Story.filter_stories($hidden,$flagged,$active) # passing a list of all stories to the view .
    if @stories.nil?
      @stories = []
    end
  end

  def new
	@story = Story.new
  end

  def create
   @story = Story.new(params[:title], params[:date], params[:body], params[:rank], params[:deleted], params[:hidden], params[:likes], params[:dislikes], params[:flags], params[:interest])

  end

  def destroy
 
  end
   

=begin 
#description: recommend_story_mobile_show is a method that calls the view of the recommendation page with a list of friends email for the user to select one of them or to write down an email on his own and then click the button send which will call the recommend_success_mobile_show method to send the recommendation
#input: story_id
#output: view for a form and a list for the user to select a friend from and write down the message or the email
#Author=> khaled.elbhaey
=end
  def recommend_story_mobile_show()
    @storyid=params[:sid]
    @user=current_user
    @flistemail=@user.get_friends_email()
    @text="Sorry you don't have any friends  "
    if @flistemail.empty?
      flash[:hint]="#{@text}<a href=\"/mob/friendship/index\">
      <h7 style=\"color:#0000A0;\">Find friend</h7> </a> $blue"
    end
    render :layout => "mobile_template"
  end

=begin 
#description: recommend_success_mobile_show is a method to recommend specific story to another friend via email so an email and the recommendation go to that email if the email isnot in the database an invitation shall be sent to him
#input: story_id, inputs of the form(email and message)
#output: a message that tell the user weather the recommendation was successful or not
#Author=> khaled.elbhaey
=end
  def recommend_success_mobile_show()
    @storyid=params[:sid]
    @user=current_user
    @listemail=params[:lemail]
    @friendmail=params[:email]
    @message=params[:message]
    @useremail=@user.email
    @story=Story.get_story(@storyid)
    @storytit=@story.title
    @storybod=@story.content
    @successflag=true
    @username=@user.email.split("@").first
    @logmessage = @username.to_s+" has recommended a story '"+ 
    @storytit.to_s + "'"
    regex = Regexp.new('^(\s*[a-zA-Z0-9\._%-]+@[a-zA-Z0-9\.-]+\.[a-zA-Z]{2,4}\s*([,]{1}[\s]*[a-zA-Z0-9\._%-]+@[a-zA-Z0-9\.]+\.[azA-Z]{2,4}\s*)*)$')
    @story_url=@story.story_link

		if @friendmail==""
			if @listemail.nil?
			   @successflag=false
         flash[:notice]="Please choose an email from the list or write down one $red" 
			else
			 Emailer.recommend_story(@useremail, @listemail, @message, @storytit, @story_url).deliver
			 Log.create!(loggingtype: 2,user_id_1: @user.id,user_id_2: nil,admin_id: nil, 
				story_id: @storyid,interest_id: @interest_id,message: @logmessage )
        flash[:notice]="Recommendation sent $green"
			end
		else
			if(!@friendmail.match(regex))
				   @successflag=false
           flash[:notice]="Please enter a valid email $red"
			else
			  if !@user.has_account(@friendmail)
				    Emailer.invite_to_app(@useremail, @friendmail, @message,
            @storytit, @story_url).deliver
            flash[:notice]="Recommendation sent $green" 
			  else
				    Emailer.recommend_story(@useremail, @friendmail, @message,
            @storytit, @story_url).deliver
            flash[:notice]="Recommendation sent $green"
			  end
			Log.create!(loggingtype: 2,user_id_1: @user.id,user_id_2: nil,admin_id: nil, 
				story_id: @storyid,interest_id: @interest_id,message: @logmessage )

			end
		end
    redirect_to :action => "recommend_story_mobile_show" ,:sid => params[:sid]
    
  end

#this method returns friend emails and ids when takes the user id.
def get_friend_id()
 @useremail=params[:email] 
 @id = User.find_by_email(@useremail).id
 render text: @id.to_s
end


=begin 
#description: liked_mobile_show is a method to view to the user a list of friends who liked specific story (calls the view of the list)
#input: story_id
#output: a list of names of friends who liked this story
#Author=> khaled.elbhaey
=end
  def liked_mobile_show
    @storyid=params[:id]
    @story=Story.get_story(@storyid)
    @user=current_user
    @friends=@story.view_friends_like(@user)
    if @friends.empty?
      flash[:no_friends] = "Sorry , You do not have any friends who liked this story $red"
      redirect_to :action => "get" ,:sid => params[:id]  
    else
      render :layout => "mobile_template" 
    end
  end


=begin 
#description: disliked_mobile_show is a method to view to the user a list of friends who disliked specific story (calls the view of the list)
#input: story_id
#output: a list of names of friends who disliked this story
#Author=> khaled.elbhaey
=end 
  def disliked_mobile_show
    @storyid = params[:id]
    @story=Story.get_story(@storyid)
    @user = current_user
    @friends=@story.view_friends_dislike(@user)
    if @friends.empty?
      flash[:no_friends] = "Sorry , You do not have any friends who disliked this story $red"
      redirect_to :action => "get" ,:sid => params[:id]  
    else
      render :layout => "mobile_template" 
    end
  end
=begin
  This method passes the three parameters to filter_stories method in the story model where the array of stories is returned
  Inputs: three flags: hidden,flagged and active
  Outputs : non
  Author: Bassem
=end
  def filter
    $hidden = params[:hidden]
    $flagged = params[:flagged]
    $active = params[:active]
    redirect_to "/stories"
    end


end
