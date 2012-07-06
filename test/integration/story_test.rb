require 'test_helper'

class StoryTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

#Author: khaled.elbhaey 
  test "should route to disliked_mobile_show" do
    assert_routing 'mob/stories/disliked_mobile_show/1', { :controller => "stories", :action => "disliked_mobile_show", :id => "1"}
  end
#Author: khaled.elbhaey 
  test "should route to liked_mobile_show" do
    assert_routing 'mob/stories/liked_mobile_show/1', { :controller => "stories", :action => "liked_mobile_show", :id => "1"}
  end
#Author: khaled.elbhaey 
  test "should route to recommend_story_mobile_show" do
    assert_routing 'mob/stories/recommend_story_mobile_show/1', { :controller => "stories", :action => "recommend_story_mobile_show", :sid => "1"}
  end


=begin
 Author : Omar
=end
	test "should route to readmore view" do
            assert_routing 'stories/1/get', { :controller => "stories", :action =>    		            "get", :id => "1"}
  	end

end

