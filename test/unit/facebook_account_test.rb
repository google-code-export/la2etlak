require 'test_helper'

class FacebookAcountTest < ActiveSupport::TestCase
   # Author : Menisy
  test "should not be able to add a facebook account without oauth token" do 
    user = User.new
    user.name = 'user1'
    user.email  = 'user@gmail.com'
    user.save
    f_account = FacebookAccount.new
    f_account.auth_secret = 'asdfadsf'
    f_account.user = user 
    assert !f_account.save, 'Should not save without oauth token'
  end 

  # Author : Menisy
  test "should not be able to add a facebook account without oauth secret" do 
    user = User.new
    user.name = 'user1'
    user.email  = 'user@gmail.com'
    user.save
    f_account = FacebookAccount.new
    f_account.auth_token = 'asdfadsf'
    f_account.user = user 
    assert !f_account.save, 'should not save without oauth secret token'
  end 

  # Author : Menisy
  test "should not be able to add a facebook account with a duplicate user id" do 
    duplicate_user = FacebookAccount.first.user
    f_account = FacebookAccount.new
    f_account.auth_token = 'asdfadsf'
    f_account.auth_secret = 'asadfasdf'
    f_account.user = duplicate_user
    assert !f_account.save, 'Should not save a Facebook account with duplicate user' 
  end 

  # Author: Menisy
  test "should be able to add a Facebook account" do 
    user = User.new
    user.name = 'user1'
    user.email  = 'user@gmail.com'
    user.save
    f_account = FacebookAccount.new
    f_account.auth_token = 'asdfadsf'
    f_account.auth_secret = 'asadfasdf'
    f_account.user = user 
    assert f_account.save, 'should save when all users requirement are valid'
  end 

  test "should get facebook feed" do
    fb = facebook_accounts(:one)
    fb.user = users(:ben)
    feed = fb.get_feed
    assert feed.length > 0 , "Length of feed array should be greater than zero"
    assert feed.first.class.name == "Story" , "Feed type must be story"
    assert feed.first.category == "Facebook" , "Stories category must be Facebook"
  end 

  test "should get facebook status" do
    fb = facebook_accounts(:one)
    fb.user = users(:ben)
    feed = fb.get_feed
    feed.each do |f|
      if f.title.index"changed his status"
        assert true
      end
    end
  end 

  test "should like a post" do
    u1 = users(:ben)
    u1.facebook_account = facebook_accounts(:one)
    assert  u1.facebook_account.fb_like("1259868446_4387718092004")    
  end

  test "should comment on a post" do
    u1 = users(:ben)
    u1.facebook_account = facebook_accounts(:one)
    x = u1.facebook_account.fb_comment("1259868446_4387718092004", "ana aho")
    comments = u1.facebook_account.fb_get_comments("1259868446_4387718092004")
    assert_equal( comments.last["id"], x["id"], "Should have found my comment" )
    assert_equal( comments.last["message"], "ana aho", "Should have found my comment" )

  end


end
