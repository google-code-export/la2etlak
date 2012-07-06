require 'test_helper'

class FlickrAccountTest < ActiveSupport::TestCase

=begin
  
  Hi Menis: I think your familiar with most of these tests so I will not
  talk about it. I just added one more test to check that the feed is empty when
  wrong token is there (this is supposed to happen if smthn went wrong).
  Anways Have fun ;) 

  Author:3OABD
=end

   
  test "should not be able to add a flickr account without oauth token" do 
    user = users(:ben)
    f_account = FlickrAccount.new
    f_account.secret_key = 'asdfadsf'
    f_account.user = user 
    assert !f_account.save, 'Should not save without oauth token'
  end 

  test "should not be able to add a flickr account without oauth secret" do 
    user = users(:ben)
    f_account = FlickrAccount.new
    f_account.consumer_key = 'asdfadsf'
    f_account.user = user 
    assert !f_account.save, 'should not save without oauth secret token'
  end 

  test "should not be able to add a flickr account with a duplicate user id" do 
    duplicate_user = FlickrAccount.first.user
    f_account = FlickrAccount.new
    f_account.consumer_key = 'asdfadsf'
    f_account.secret_key = 'asadfasdf'
    f_account.user = duplicate_user
    assert !f_account.save, 'Should not save a flickr account with duplicate user' 
  end 

  test "should be able to add a flickr account" do 
    user = users(:ben)
    f_account = FlickrAccount.new
    f_account.consumer_key = 'asdfadsf'
    f_account.secret_key = 'asadfasdf'
    f_account.user = user 
    assert f_account.save, 'should save when all users requirement are valid'
  end 

  test "flickr feed should be a list of stories" do 
    f_account = flickr_accounts(:one)
    stories = f_account.get_feed
    assert_equal stories.first.class.name, "Story", 'get_feed should return a list of stories'
    assert stories.first.category == "flickr" , "Stories category must be Flickr"
  end 

  test "flickr empty feed when wrong token" do
    f_account = FlickrAccount.new
    f_account.secret_key = 'asdfadsf'
    f_account.secret_key = 'asadfasdf'
    assert f_account.get_feed.length==0 , "Feed should be empty when token is wrong"
  end


end