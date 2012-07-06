require 'twitter'

class TwitterAccount < ActiveRecord::Base

=begin  
   Those are our Consumer Token and Consumer secret that twitter
   provided us. This correspons our entity to twitter. The Consumer
   Secret should be saved in a safe place. 
   Author: Yahia
=end    
  CONSUMER_TOKEN  = 'A8Fh0r4H5DJl3dCYLGbXyQ'
  CONSUMER_SECRET = '614KLHBIR3jyAyULABnxeJ7jUWz5jDG2rs7K1zY20Q' 

=begin  
  auth_secret and auth_token are the access keys to the twitter 
  accounts. Twitter provides them to us in phase to in the 
  authentication. see twitter_requests_controller.rb for more info 
=end
  attr_accessible :auth_secret, :auth_token
  belongs_to :user, class_name: "User" 


  validates :auth_secret, presence: true
  validates :auth_token, presence: true
  validates :user_id, presence: true 
  validates :user_id, uniqueness: true

=begin
   This method configure twitters Gem paramters. This configuratin 
   should be done whenever a feed will be request or a tweet will be
   posted
   Author: Yahia
=end   
  def config_twitter
    Twitter.configure do |config|
      config.consumer_key         = CONSUMER_TOKEN
      config.consumer_secret      = CONSUMER_SECRET
      config.oauth_token          = self.auth_token
      config.oauth_token_secret   = self.auth_secret
    end
  end 

=begin
  This methods is a simple method to get the feed from a twitter account.
  The heart of this method is the much-richer Twitter::Client#home_timeline
  method. Which has many featurs and options. But for the sake of simplicity 
  I have pruned the option to one optional option which is the pages.  a page
  contains 20 tweets. Adding a new options will be as simple as putting them 
  into a hash and providing them to the home_timeline method. 
  Input: count, is the number of desired tweets that the method will return 
  Output: a list of [count] tweets that are converted to stories 
  Author: Yahia
=end
  def get_feed(count=20)
    begin 
      self.config_twitter
      feed = Twitter.home_timeline(:count => count)
      stories = Array.new
      feed.each do |tweet|
        temp = TwitterAccount.convert_tweet_to_story(tweet) 
        stories.push(temp) 
      end 
      stories
    rescue 
      puts 'EXCEPTION RAISED IN TWITTER_ACCOUNT#GET_FEED'
      [] 
    end 
  end 

=begin 
  This method converts a Twitter::Status to Story class. This representation
  was asked by C1 
  Input: Tweet
  Output:Story
  Author: Yahia
=end  
  def self.convert_tweet_to_story(tweet)
    story = Story.new
    story.instance_variables
    story.title = tweet['user']['name']
    story.content = tweet['text']
    story.category = 'twitter'
    story.media_link = tweet.attrs["user"]["profile_image_url"]
    return story 
  end

=begin
  This return the consumer for twitter authentication
  Input: Nothing
  Output: Twitter::Consumer
  Author: Yahia  
=end
  def self.twitter_consumer
  # The readkey and readsecret below are the values you get during registration
    OAuth::Consumer.new(CONSUMER_TOKEN, CONSUMER_SECRET,
                      { :site=>"http://twitter.com" })
  end

end
