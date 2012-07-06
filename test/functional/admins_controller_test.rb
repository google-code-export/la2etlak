require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup :activate_authlogic
  test "AdminMainPage contains no of users who signed in today zero" do
  	admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
  	AdminSession.create admin1
  	get :index
  	assert_select "li[id=no_users_signed_in]", "0 sign ins"
  end

  test "AdminMainPage contains no of users who signed in today not zero" do
    usr=User.new(:email=>"example@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    assert usr.save
    log=UserLogIn.new
    log.user=usr
    assert log.save
    count2=User.get_no_of_users_signed_in_today
  	admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
  	AdminSession.create admin1
  	get :index
  	assert_select "li[id=users_signed_in]", "#{count2} sign ins"
  end
#Author MESAI
  #this test is to make sure that the route is not lost 
   test "AdminMainPageRoute" do
      assert_routing '/admins/index', { :controller => "admins", :action => "index"}
     end
   #this test is to make sure that the main page does exist and i get a 200OK response     
   test "AdminMainPage" do
      admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
   	  AdminSession.create admin1
   	  get :index
      assert_response :success ,message:"Go to main page"
     end
   #this test is to make sure that i have a field for search and autocomplete
   test "AutoCompleteFieldExistance" do
     admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
  	  AdminSession.create admin1
  	  get :index
     assert_select "input[id=autocomplete_query]",message:"Should find a TextField for search"
   end
   #this test is to make sure that that there is a hidden div for results of auto complete
   test "AutoCompleteResultDiv" do
      admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
   	  AdminSession.create admin1
   	  get :index
     assert_select "div[id=autocomplete_query_auto_complete]",message:"Should find a Div for results"
   end
    #this test is for testing the existance of feed div
    test "ExistanceOfFeedsDiv" do
       admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    	  AdminSession.create admin1
    	  get :index
        assert_select "div[id=feeds]",message:"Should find a Div for feeds"
       end
    #test get_feed
    test "get feeds" do
          Interest.create!(:name => "Music", :description => "Music washes away from the soul the dust of everyday life")
          @feeds = Admin.get_feed
          assert(@feeds.length >= 1,"should find number of feeds greater than 1")
        end
        
        
  #Author: Lydia
  test "route of search page exists" do
     assert_routing '/admins/search' , { :controller => "admins", :action => "search"}
  end
  
  #Author: Lydia
  test "results of empty search query exists" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      post :search, :query=>"",:autocomplete=>{:query =>""}
  end
  
  #Author: Lydia
  test "results of nonempty search query exists" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      post :search, :query=>"lydia", :autocomplete=>{:query =>"lydia"}
  end
  
  #Author: Lydia
  test "empty search query" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      results = Admin.search("")
      if not results.nil?
      	users = results[0]
      	stories = results[1]
      	interests = results[2]
      	uCount = users.count
      	sCount = stories.count
      	iCount = interests.count
      else
      	uCount = 0
      	sCount = 0
      	iCount = 0
      end
      post :search, :query=>"",:autocomplete=>{:query =>""}
      assert_select "div[id=noSearchQuery]",'Please enter query into the search bar.' do
        assert_select "div[class=well-user-component]" , uCount
        assert_select "div[class=well-story-component]" , sCount
        assert_select "div[class=well-interest-component]" , iCount
      end
  end
  
  #Author: Lydia
  test "no results found" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      results = Admin.search("blabla")
      if not results.nil?
      	users = results[0]
      	stories = results[1]
      	interests = results[2]
      	uCount = users.count
      	sCount = stories.count
      	iCount = interests.count
      else
      	uCount = 0
      	sCount = 0
      	iCount = 0
      end
      post :search, :query=>"blabla",:autocomplete=>{:query =>"blabla"}
      assert_select "div[id=noSearchQuery]",'There are no matching results.' do
        assert_select "div[class=well-user-component]" , uCount
        assert_select "div[class=well-story-component]" , sCount
        assert_select "div[class=well-interest-component]" , iCount
      end
  end
  
  #Author: Lydia
  test "get results of nonempty search query" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      User.create!(name: "lydia",email: "loulou@mail.com", password: "123456", password_confirmation: "123456")
      int = Interest.create!(name: "lydia", description: "Description of Test Interest")
      story = Story.new
      story.title = "lydia"
      story.interest = int
      story.content = "Test content"
      story.save
      results = Admin.search("lydia")
      if not results.nil?
      	users = results[0]
      	stories = results[1]
      	interests = results[2]
      	uCount = users.count
      	sCount = stories.count
      	iCount = interests.count
      else
      	uCount = 0
      	sCount = 0
      	iCount = 0
      end
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=usersSearchResults]" do
        assert_select "div[class=well-user-component]" , uCount
      end
      assert_select "div[id=storiesSearchResults]" do
        assert_select "div[class=well-story-component]" , sCount
      end
      assert_select "div[id=interestsSearchResults]" do
        assert_select "div[class=well-interest-component]" , iCount
      end
  end
  
  #Author: Lydia
  test "at the beginning only 3 components exist" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      User.create!(name: "lydia",email: "loulou1@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou2@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou3@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou4@mail.com", password: "123456", password_confirmation: "123456")
      users = Admin.search_user("lydia")
      uCount = users.count
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=usersSearchResults]" do
        assert_select "div[class=well-user-component]" , 3
      end
  end
  
  #Author: Lydia
  test "when there are results filteration exists" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      User.create!(name: "lydia",email: "loulou@mail.com", password: "123456", password_confirmation: "123456")
      int = Interest.create!(name: "lydia", description: "Description of Test Interest")
      story = Story.new
      story.title = "lydia"
      story.interest = int
      story.content = "Test content"
      story.save
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=filterPanel]" do
        assert_select "li[id=allResults]", 1
        assert_select "li[id=allUsers]", 1
        assert_select "li[id=allStories]", 1
        assert_select "li[id=allInterests]", 1
      end
  end
  
  #Author: Lydia
  test "when there are no results filteration does not exist" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=filterPanel]" do
        assert_select "li[id=allResults]", 0
        assert_select "li[id=allUsers]", 0
        assert_select "li[id=allStories]", 0
        assert_select "li[id=allInterests]", 0
      end
  end
  
  #Author: Lydia
  test "viewing all users results" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      User.create!(name: "lydia",email: "loulou@mail.com", password: "123456", password_confirmation: "123456")
      users = Admin.search_user("lydia")
      uCount = users.count
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      post :all_results, :type=>"1", :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=searchResults]" do
        assert_select "div[class=well-user-component]" , uCount
      end
  end
  
  #Author: Lydia
  test "viewing all stories results" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      int = Interest.create!(name: "lydia", description: "Description of Test Interest")
      story = Story.new
      story.title = "lydia"
      story.interest = int
      story.content = "Test content"
      story.save
      stories = Admin.search_story("lydia")
      sCount = stories.count
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      post :all_results, :type=>"2", :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=searchResults]" do
        assert_select "div[class=well-story-component]" , sCount
      end
  end
  
  #Author: Lydia
  test "viewing all interests results" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      Interest.create!(name: "lydia", description: "Description of Test Interest")
      interests = Admin.search_interest("lydia")
      iCount = interests.count
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      post :all_results, :type=>"3", :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=searchResults]" do
        assert_select "div[class=well-interest-component]" , iCount
      end
  end
  
  #Author: Lydia
  test "no all results for some category" do
      admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      post :all_results, :type=>"3", :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=searchResults]" do
      	assert_select "div[id=noSearchQuery]"
        assert_select "div[class=well-interest-component]" , 0
      end
  end
  
  #Author: Lydia
  test "if more than 10 results pagination exists" do
  	  admin = Admin.create!(email:"lydia@gmail.com", password:"123456", password_confirmation:"123456")
      AdminSession.create admin
      User.create!(name: "lydia",email: "loulou1@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou2@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou3@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou4@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou5@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou6@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou7@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou8@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou9@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou10@mail.com", password: "123456", password_confirmation: "123456")
      User.create!(name: "lydia",email: "loulou11@mail.com", password: "123456", password_confirmation: "123456")
      users = Admin.search_user("lydia")
      uCount = users.count
      post :search, :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      post :all_results, :type=>"1", :query=>"lydia",:autocomplete=>{:query =>"lydia"}
      assert_select "div[id=searchResults]" do
        assert_select "div[class=apple_pagination]"
      end
  end
end
