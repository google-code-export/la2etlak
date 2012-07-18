=begin 
class Friendship < ActiveRecord::Base
	attr_accessible :user_id
	attr_accessible :friend_id	
  include Amistad::FriendshipModel
end
=end
class Friendship
    include Mongoid::Document
    include Mongoid::Timestamps
    field :user_id, type: Integer #String
    field :friend_id, type: Integer #String
    field :blocker_id, type: Integer #String
    field :pending, type: Boolean

    index({ user_id: 1 , friend_id: 1 }, { unique: true, name: "index_friendships_on_user_id_and_friend_id" })

    attr_accessible :user_id
    attr_accessible :friend_id	
    include Amistad::FriendshipModel
end
