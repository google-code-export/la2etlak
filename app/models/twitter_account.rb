require 'twitter'

class TwitterAccount < ActiveRecord::Base

  include Mongoid::Document
  include Mongoid::Timestamps

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



  field :user_id, type: Integer
  field :auth_token, type: String
  field :auth_secret, type: String
  #field :created_at, type: datetime 
  #field :created_at, type: datetime 
  #Since I added the timestamps we dont need them 

  attr_accessible :auth_secret, :auth_token
  belongs_to :user, class_name: "User" 

  validates :auth_secret, presence: true
  validates :auth_token, presence: true
  validates :user_id, presence: true 
  validates :user_id, uniqueness: true

end