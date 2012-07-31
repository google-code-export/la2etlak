class CommentsController < ApplicationController

  before_filter :user_authenticated?, :except => [:destroy]
  before_filter :admin_authenticated?, :only => [:destroy]
  before_filter {user_verified?}
  respond_to :html,:json
=begin
  This controller is solely created by me, Menisy.
=end

=begin
  new action included by default in the controller
  upon generation
  Author: Menisy
=end   
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
      end
    end

# included by default upon generation
  def show
    respond_with(@comment = Comment.find(params[:id]))
  end 

=begin
  An action to create a new comment
  It set the correct attributes of the
  comment based on the params that were passed
  in the post request, if the comment is created
  successfully the user is redirected to the story page
  from which he came.
  Otherwise the comment is not saved and the user is 
  also redirected to the story page with the appropriate
  failure flash displayed.
  Inputs: comment hash in the params of the http POST request
  Output: failure flash incase of failure
  Author: Menisy 
  Ranking: Diab 
=end 
  def create
    @comment = Comment.new
    @comment.story = Story.find(params[:comment][:story_id])
    @comment.content = params[:comment][:content]
    @comment.user = User.find(params[:comment][:user_id])
    if @comment.save
      @comment.add_to_log
       
      story = Story.find(params[:comment][:story_id])
      story.rank = story.rank + 2
      story.save
      user = User.find(params[:comment][:user_id])
      user.rank = user.rank + 3
      user.save

        #Author: Omar 
        #getting all commenters on certian story to send them all notification when another user comment on the same story
  commenters = Array.new
  for c in @comment.story.comments
  	if User.find_by_id(c.user_id) != current_user
	commenters << User.find_by_id(c.user_id)
	end
  end
  commenters = commenters.uniq
  for f in commenters
	   UserNotification.create(owner: f.id , user: @comment.user.id , story:@comment.story.id , comment:@comment.id , notify_type: 4 , new: true)
     f.notifications =  f.notifications.to_i + 1
     f.save
	end   
      redirect_to :controller => "stories", :action => "get" , :id => @comment.story.id
    else
      flash[:empty_comment_danger] = "Please enter something to comment. $red"
      redirect_to :controller => "stories", :action => "get" , :id => params[:comment][:story_id]
    end
  end

  def index
    respond_with(@comments = Comment.all)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.delete_comment
    if $source == "show"
      redirect_to :controller=>'stories', :action => 'show', :id => @comment.story_id
    elsif $source == "stories_index"
      redirect_to :controller=>'stories', :action => 'index'
    elsif $source == "admins_index"
      redirect_to :controller=>'admins', :action => 'index'
    elsif $source == "get"
      redirect_to :controller=>'stories', :action => 'get', :id => @comment.story_id
    end
  end
end
