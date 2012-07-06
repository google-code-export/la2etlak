require 'test_helper'

class TwitterAccountTest < ActiveSupport::TestCase

  # author : Yahia
  test "should not be able to add a twitter account without oauth token" do 
    user = users(:ben)
    t_account = TwitterAccount.new
    t_account.auth_secret = 'asdfadsf'
    t_account.user = user 
    assert !t_account.save, 'Should not save without oauth token'
  end 

  # author : Yahia
  test "should not be able to add a twitter account without oauth secret" do 
    user = users(:ben)
    t_account = TwitterAccount.new
    t_account.auth_token = 'asdfadsf'
    t_account.user = user 
    assert !t_account.save, 'should not save without oauth secret token'
  end 

  # author : Yahia
  test "should not be able to add a twitter account with a duplicate user id" do 
    duplicate_user = TwitterAccount.first.user
    t_account = TwitterAccount.new
    t_account.auth_token = 'asdfadsf'
    t_account.auth_secret = 'asadfasdf'
    t_account.user = duplicate_user
    assert !t_account.save, 'Should not save a twitter account with duplicate user' 
  end 

  test "should be able to add a twitter account" do 
    user = users(:ben)
    t_account = TwitterAccount.new
    t_account.auth_token = 'asdfadsf'
    t_account.auth_secret = 'asadfasdf'
    t_account.user = user 
    assert t_account.save, 'should save when all users requirement are valid'
  end 


  # author : Yahia
  test "twitter feed should be a list of stories" do 
    t_account = twitter_accounts(:one)
    stories =   t_account.get_feed
    assert_equal stories.first.class.name, "Story", 'get_feed should return a list of stories'
  end 

end
