class CommentsController < ApplicationController

  before_filter {user_authenticated?}
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
=end 
  def create
    @comment = Comment.new
    @comment.story = Story.find(params[:comment][:story_id])
    @comment.content = params[:comment][:content]
    @comment.user = User.find(params[:comment][:user_id])
    if @comment.save
      @comment.add_to_log
      redirect_to :controller => "stories", :action => "get" , :id => @comment.story.id
    else
      flash[:empty_comment_danger] = "Please enter something to comment. $red"
      redirect_to :controller => "stories", :action => "get" , :id => params[:comment][:story_id]
    end
  end

  def index
    respond_with(@comments = Comment.all)
  end
end
