require 'test_helper'

class CommentTest < ActiveSupport::TestCase

   # Author: Menisy
  test "should not save without content" do
    comment = Comment.new
    assert !comment.save, "Should not save without content"
  end

   # Author: Menisy
  test "should save with content" do  
    comment = Comment.new(:content => "I'm the content")
    comment.story = Story.first
    comment.user = User.first
    assert comment.save, "Should save with content"
  end

   # Author: Menisy
  test "should not save without user" do
  	comment = Comment.new
  	comment.content = "content again"
  	comment.story = Story.first
  	assert !comment.save , "Should not save without a user"
  end

   # Author: Menisy
  test "should not save without story" do
  	comment = Comment.new
  	comment.content = "content again"
  	comment.user = User.first
  	assert !comment.save , "Should not save without a story"
  end

   # Author: Menisy
  test "should up a comment" do
    assert_difference('CommentUpDown.find_all_by_action(1).count',1) do
      up_comment
    end
  end

   # Author: Menisy
  test "should down a comment" do
    assert_difference('CommentUpDown.find_all_by_action(2).count',1) do
      down_comment
    end
  end

   # Author: Menisy
  test "should un-up when downed" do
    down_comment
    assert_difference('CommentUpDown.find_all_by_action(2).count',-1) do
      up_comment
    end
  end

   # Author: Menisy
  test "should un-down when upped" do
    up_comment
    assert_difference('CommentUpDown.find_all_by_action(1).count',-1) do
      down_comment
    end
  end

   # Author: Menisy
  test "should un-up when re-upped" do
    up_comment
    assert_difference('CommentUpDown.find_all_by_action(1).count',-1) do
      up_comment
    end
  end

   # Author: Menisy
  test "should un-down when re-downed" do
    down_comment
    assert_difference('CommentUpDown.find_all_by_action(2).count',-1) do
      down_comment
    end
  end

   # Author: Menisy
  def up_comment
    comment = Comment.first
    comment.content = "content"
    user = User.first
    comment.user = user
    comment.story = Story.first
    comment.save
    comment.up_comment(user)
  end

   # Author: Menisy
  def down_comment
    comment = Comment.first
    comment.content = "content"
    user = User.first
    comment.user = user
    comment.story = Story.first
    comment.save
    comment.down_comment(user)
  end  

  # Author: Lydia
  test "comment is deleted from database RED" do
    int = Interest.create!(name: "Test Interest", description: "Description
    of Test Interest")
    story = Story.new
    story.title = "Test Story"
    story.interest = int
    story.content = "Test content"
    story.save
    user = User.create!(name: "Test user1",email: "test1@user.com",password: "123456",password_confirmation: "123456")
    comment = Comment.new(:content => "Test content")
    comment.story = story
    comment.user = user
    comment.save
    comment.delete_comment
    assert_true(comment.deleted == true)
  end
end
