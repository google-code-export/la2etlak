class Friendship < ActiveRecord::Base
	attr_accessible :user_id
	attr_accessible :friend_id	
  include Amistad::FriendshipModel
end
