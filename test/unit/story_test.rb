require 'test_helper'

class StoryTest < ActiveSupport::TestCase

  #test "the truth" do
  #  assert true
  #end
  
   #Author: Lydia
  test "no likes should return an empty list" do
    int = Interest.create!(name: "Test Interest", description: "Description
    of Test Interest")
    story = Story.new
    story.title = "Test Story"
    story.interest = int
    story.content = "Test content"
    story.save
    assert_equal(story.liked.count, 0)
  end
  
  #Author: Lydia
  test "no dislikes should return an empty list" do
    int = Interest.create!(name: "Test Interest", description: "Description
    of Test Interest")
    story = Story.new
    story.title = "Test Story"
    story.interest = int
    story.content = "Test content"
    story.save
    assert_equal(story.disliked.count, 0)
  end
  
  #Author: Lydia
  test "some likes should return 3" do
    int = Interest.create!(name: "Test Interest", description: "Description
    of Test Interest")
    story = Story.new
    story.title = "Test Story"
    story.interest = int
    story.content = "Test content"
    story.save
    user1 = User.create!(name: "Test user1",email: "test1@user.com",password: "123456",password_confirmation: "123456")
    user2 = User.create!(name: "Test user2",email: "test2@user.com",password: "123456",password_confirmation: "123456")
    user3 = User.create!(name: "Test user3",email: "test3@user.com",password: "123456",password_confirmation: "123456")
    user1.thumb_story(story,1)
    user2.thumb_story(story,1)
    user3.thumb_story(story,1)
    assert_equal(story.liked.count, 3)
  end
  
  #Author: Lydia
  test "some dislikes should return 3" do
    int = Interest.create!(name: "Test Interest", description: "Description
    of Test Interest")
    story = Story.new
    story.title = "Test Story"
    story.interest = int
    story.content = "Test content"
    story.save
    user1 = User.create!(name: "Test user1",email: "test1@user.com",password: "123456",password_confirmation: "123456")
    user2 = User.create!(name: "Test user2",email: "test2@user.com",password: "123456",password_confirmation: "123456")
    user3 = User.create!(name: "Test user3",email: "test3@user.com",password: "123456",password_confirmation: "123456")
    user1.thumb_story(story,-1)
    user2.thumb_story(story,-1)
    user3.thumb_story(story,-1)
    assert_equal(story.disliked.count, 3)
  end
  
  #Author: Lydia
  test "user likes then dislikes" do
    int = Interest.create!(name: "Test Interest", description: "Description
    of Test Interest")
    story = Story.new
    story.title = "Test Story"
    story.interest = int
    story.content = "Test content"
    story.save
    user = User.create!(name: "Test user1",email: "test1@user.com",password: "123456",password_confirmation: "123456")
    user.thumb_story(story,1)
    assert_equal(story.liked.count, 1)
    user.thumb_story(story,-1)
    assert_equal(story.liked.count, 0)
  end
  
  #Author: Lydia
  test "user dislikes then likes" do
    int = Interest.create!(name: "Test Interest", description: "Description
    of Test Interest")
    story = Story.new
    story.title = "Test Story"
    story.interest = int
    story.content = "Test content"
    story.save
    user = User.create!(name: "Test user1",email: "test1@user.com",password: "123456",password_confirmation: "123456")
    user.thumb_story(story,-1)
    assert_equal(story.disliked.count, 1)
    user.thumb_story(story,1)
    assert_equal(story.disliked.count, 0)
  end

#Author : Shafei
    test "story get rank all time" do
		user = users(:one)
		story = stories(:one)
		comment = comments(:one)
		comment.user = user
		comment.story = story
		comment.save
		assert_equal(story.get_story_rank_all_time(),31,"Action returns wrong number")
	end
	
#Author : Shafei
    test "story get rank last 30 days" do
		user = users(:one)
		story = stories(:one)
		comment = comments(:two)
		comment.created_at = 40.days.ago
		comment.user = user
		comment.story = story
		comment.save
		comment2 = comments(:one)
		comment2.user = user
		comment2.story = story
		comment2.save
		assert_equal(story.get_story_rank_all_time(),32,"Action returns wrong number")
	end
	
#Author : Shafei
	test "stories get rank all time" do
		top_stories = Array.new#
		top_stories << stories(:two)
		top_stories << stories(:one)
		top_stories << stories(:three)
		top_stories << stories(:four)
		top_stories << stories(:five)
	
		for i in 0...5
			assert_equal(top_stories[i].id, Story.get_stories_ranking_all_time[i].id, "Ranking not correct")
		end
	end
	
#Author : Shafei
	test "stories get rank last 30 days" do
		top_stories = Array.new#
		top_stories << stories(:two)
		top_stories << stories(:one)
		top_stories << stories(:three)
		top_stories << stories(:four)
		top_stories << stories(:five)
		for i in 0...5
			assert_equal(top_stories[i].id, Story.get_stories_ranking_last_30_days[i].id, "Ranking not correct")
		end
	end
end
