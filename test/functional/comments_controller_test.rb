require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
   # Author: Menisy
   setup "activate_authlogic"
  test "should create comment" do
  	user = users(:ben)
  	UserSession.create(user)
    assert_difference('Comment.count') do
      post :create, :comment => {:content => "lololo" , :story_id => Story.first.id , :user_id => User.first.id}
    end
    assert_redirected_to :controller => "stories" , :action => "get", :id => Story.first.id
  end

  # Author: Menisy
  test "should not create comment" do
  	user = users(:ben)
  	UserSession.create(user)
  	post :create, :comment => {:content => "", :story_id => Story.first.id, :user_id => users(:ben).id}
  	assert_redirected_to :controller => "stories" , :action => "get", :id => Story.first.id
  	assert_not_nil flash[:empty_comment_danger]
  end
end
