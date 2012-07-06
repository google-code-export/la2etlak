require 'test_helper'

class FeedTest < ActiveSupport::TestCase

  # author : Gasser
  test "admin should enter the same feed for more than one interest " do
     feed1 = Feed.new(:link=>"http://www.xkcd.com/rss.xml")
     feed2 = Feed.new(:link=>"http://www.xkcd.com/rss.xml")
     interest1 = Interest.create!(:name=>"interest1")
     interest2 = Interest.create!(:name=>"interest2")
     feed1.interest = interest1
     feed2.interest = interest2
     feed1.save
     feed2.save
     assert_equal feed1.interest.name, "interest1"
     assert_equal feed2.interest.name, "interest2"
  end


end
