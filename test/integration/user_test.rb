require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  setup :activate_authlogic


  ##########Author: Diab ############
  test "should route to user statistics page" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
    assert_routing '/users/statistics/1', { :controller => "statistics", :action => "users" , :id => "1"}
   end 
  
    
 

    #Author : Mina Adel
    test "route to main feed" do
      assert_routing 'mob/main_feed', {:controller => "users", :action => "feed", :id => "1"}
    end
    
    #Author: Rana
    test "should get to block story" do
      assert_routing 'mob/block_story/1', {:controller => "users", :action => "block_story", :id => "1" }
    end

    #Author: Rana   
    test "should get to block interest" do
      assert_routing 'mob/block_interest/1', {:controller => "users", :action => "block_interest", :id => "1" }
    end

    #Author: Rana   
    test "should get to block interest from toggle" do
      assert_routing 'mob/block_interest_from_toggle/1', {:controller => "users", :action => "block_interest_from_toggle", :id => "1" }
    end

    #Author: Rana   
    test "should get to unblock interest" do
      assert_routing 'mob/unblock_interest/1', {:controller => "users", :action => "unblock_interest", :id => "1" }
    end
  
    #Author: Rana   
    test "should get to unblock interest from toggle" do
      assert_routing 'mob/unblock_interest_from_toggle/1', {:controller => "users", :action => "unblock_interest_from_toggle", :id => "1" }
    end

    #Author: Rana   
    test "should get to block friend" do
      assert_routing 'mob/block_friends_feed/1', {:controller => "users", :action => "block_friends_feed", :id => "1" }
    end

    #Author: Rana   
    test "should get to unblock friend" do
      assert_routing 'mob/unblock_friends_feed/1', {:controller => "users", :action => "unblock_friends_feed", :id => "1" }
    end

    #Author: Rana   
    test "should get to view friends feed" do
      assert_routing 'mob/friends_feed/1', {:controller => "users", :action => "friends_feed", :id => "1"}
    end

    #Author: Rana    
    test "should get to manage blocked friends" do
      assert_routing 'mob/manage_blocked_friends', {:controller => "users", :action => "manage_blocked_friends"}
    end

    #Author: Rana   
    test "should get to unblock story" do
      assert_routing 'mob/unblock_story/1', {:controller => "users", :action => "unblock_story", :id => "1" }
    end  

    #Author: Rana   
    test "should get to unblock story from undo" do
      assert_routing 'mob/unblock_story_from_undo/1', {:controller => "users", :action => "unblock_story_from_undo", :id => "1" }
    end  

    #Author: Rana    
    test "should get to manage blocked stories" do
      assert_routing 'mob/manage_blocked_stories', {:controller => "users", :action => "manage_blocked_stories"}
    end 
     
    #Author : Omar
     test "route to toggle interests" do
  	user = users(:ben)
	UserSession.create(user)      
        assert_routing '/mob/toggle', {:controller => "users", :action => "toggle"}
    end
    
end
