require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
setup :activate_authlogic
  # test "the truth" do
  #   assert true
  # end



  # Author: Menisy
  test "should up comment" do
    user1 = users(:ben)
    UserSession.create(user1)
    comment = Comment.new
    comment.user = users(:one)
    comment.story = stories(:one)
    comment.content = "testing testing 1 2"
    comment.save!
  	assert_difference('CommentUpDown.find_all_by_action(1).count',1) do
  		get :up_comment, :comment_id => comment.id
  	end
  	assert_redirected_to :action => "get"
  end

  # Author: Menisy
  test "should down comment" do
    user1 = users(:ben)
    UserSession.create(user1)
    comment = Comment.new
    comment.user = users(:one)
    comment.story = stories(:one)
    comment.content = "testing testing 1 2"
    comment.save!
  	assert_difference('CommentUpDown.find_all_by_action(2).count',1) do
  		get :down_comment, :comment_id => comment.id
  	end
  	assert_redirected_to :action => "get"
  end

  # Author: Menisy
  test "should see notification" do
    user1 = users(:ben)
    UserSession.create(user1)
  	requester = users(:five)
  	requester.invite user1
  	get :recommend_story_mobile_show, :sid => Story.first.id
  	assert_select 'div[id=notification]',true
  end

  # Author: Menisy
  test "should not see notification" do
    user1 = users(:one)
    UserSession.create(user1)
  	get :recommend_story_mobile_show, :sid => Story.first.id
  	assert_select 'div[id=notification]',false	
  end

  # Author: Menisy
  test "get show view" do
    user1 = users(:ben)
    UserSession.create(user1)
  	story = Story.first
    story.interest = interests(:one)
    story.rank = 5
    story.save!
  	comment = Comment.new
  	comment.content = "lol"
  	comment.user = User.first
  	comment.story = story
  	comment.save
  	get :mobile_show, :id => story.id
  	assert_select 'ul.nav' do
  		assert_select 'li', true
		end
		assert_select 'input[class=btn btn-large]',1
		assert_select 'div[class=story-comment-box-mobile well]',true
		assert_select 'title', {:count => 1, :text => "LA2ETLAK!"},
    "Wrong title or more than one title element"
	end

  
  
=begin 
Author : Omar
=end
  test "create story view" do
	user = users(:ben)
	UserSession.create(user)	
	st = Story.new
	st.interest_id = 1
	st.title = "title"
	st.save	
	assert get(:get , {'id' => st.id })
  end

  #Author: Bassem
  test "filter not hidden" do
    get :filter, { 'hidden' => false}
    
  end

  #Author: Bassem
  test "filter not flagged" do
  st = Story.new
  st1 = Story.new
  st.hidden=true
  get :filter ,{ 'flagged' => false}
  end
  

  #Author : Mina Adel
  test "check facebook share button exists" do
     user = users(:ben)
     UserSession.create(user)        
     st = Story.first
     st.category = "RSS"
     st.save
     assert get(:get , {'id' => st.id })
      assert_select 'a[id = "Facebook"]'
    end
  
  #Author : Mina Adel
  test "check twitter share button exists" do
     user = users(:ben)
     UserSession.create(user)        
     st = Story.first
     st.category = "RSS"
     st.save
     assert get(:get , {'id' => st.id })
      assert_select 'a[id = "Twitter"]'
    end
  
  #Author : Mina Adel
   test "check la2etlak share button exists" do
   user = users(:ben)
   UserSession.create(user)        
   st = Story.first
   st.category = "RSS"
   st.save
   assert get(:get , {'id' => st.id })
    assert_select 'a[id = "La2etlak"]'
  end

#Author: khaled.elbhaey 
  test "the view of friends who liked" do
    user1 = users(:ben)
    UserSession.create(user1)
    new_interest=Interest.create(:name=>"sport", :description=>"sport is good")
    new_story=Story.create(:title=>"messi", :content=>"won a lot", :interest_id=>1)

    list=new_story.view_friends_like(user1)
     if !list.empty?
      assert get(:liked_mobile_show, {'id' => new_story.id})
      assert_select 'div[ id=liked]'
     end
  end
#Author: khaled.elbhaey 
  test "the view of friends who disliked" do
    user1 = users(:ben)
    UserSession.create(user1)
    new_interest=Interest.create(:name=>"sport", :description=>"sport is good")
    new_story=Story.create(:title=>"messi", :content=>"won a lot", :interest_id=>1)
    list=new_story.view_friends_dislike(user1)
    if !list.empty?
      assert get(:disliked_mobile_show, {'id' => new_story.id})
      assert_select 'div[ id=disliked]'
    end
  end


#Author: khaled.elbhaey 
  test "the view of recommendation of story" do
    user1 = users(:ben)
    UserSession.create(user1)
    this_interest = Interest.create :name => "Sports", :description => "hey sporty"
    this_story= Story.new :title => "Story1", :interest_id => this_interest
    this_story.interest = this_interest
    this_story.save
    flist=user1.get_friends_email
    if !flist.empty?
      assert get(:recommend_story_mobile_show, {'sid' => this_story.id})
      assert_select 'div[ id=submit]'
      assert_select 'div[ id=recommendation]'
      assert_select 'table[ id=list]'
    else
      assert get(:recommend_story_mobile_show, {'sid' => this_story.id})
      assert_select 'div[ id=submit]'
      assert_select 'div[ id=recommendation]'
    end
    
  end
end
