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
end
