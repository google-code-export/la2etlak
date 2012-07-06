require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
 setup :activate_authlogic
  
   ##########Author: Diab ############
  test "user statistics page has a list of users who added it" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
   get :users, :id=>1
   assert_select 'div[id = shared_stories]'
 end

 ##########Author: Diab ############
 test "no shared stories by user warning" do
   admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
    u = User.new(:email=>"mail1@mail.com" , :password=>"123456" , :password_confirmation=>"123456")
    u.save
    get :users, :id=>u.id
    assert_select 'div[id = noStoriesShared]'
 end

 ##########Author: Diab ############
  test "get user statistics response" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
   get :users , :id => 1
   assert_response :success
   end 

 ##########Author: Diab ############
  test "all interests page has div chart" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
    get :all_interests
    assert_select 'div[id = interest_chart]'
   end
   
   ##########Author: Diab ############
   test "no interest warning" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
    Interest.destroy_all
    get :all_interests
    assert_select 'div[id = noInterest]'
    end

    ##########Author: Diab ############
  test "get all interests response" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
    get :all_interests
    assert_response :success
   end

   ##########Author: Diab ############
  test "interest statistics page has a list of users who added it" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
   get :interests, :id=>1
   assert_select 'div[id = adders]'
 end
 
  ##########Author: Diab ############
  test "no users added interest warning" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
    i = Interest.new(:name=>"interest1")
    i.save
    get :interests, :id=>i.id
    assert_select 'div[id = noUsersAdded]'
  end
  
   ##########Author: Diab ############
  test "get interest statistics response" do
   admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
   get :interests, :id=>1
   assert_response :success
   end 
   
	#Author : Shafei
	test "route to all users" do
		assert_routing 'admins/statistics/all_users', { :controller => "statistics", :action => "all_users"}
    end
	
	#Author : Shafei
	test "get all users response" do
		get :all_users
		assert_response :redirect
    end
	
	#Author : Shafei
	test "route to all stories" do
		assert_routing 'admins/statistics/all_stories', { :controller => "statistics", :action => "all_stories"}
    end
	
  #Author : Shafei
	test "get all stories response" do
		get :all_stories
		assert_response :redirect
    end
   
end
