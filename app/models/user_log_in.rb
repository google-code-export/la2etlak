=begin
class UserLogIn < ActiveRecord::Base
  attr_accessible :user_id
  
  belongs_to :user, class_name: "User"
end
=end

class UserLogIn
    include Mongoid::Document
    include Mongoid::Timestamps
    field :user_id, type: Integer #String
    #validates :created_at, presence: true #extra ((Timestamps)) should automatically insert it as not null
    #validates :updated_at, presence: true #extra ((Timestamps)) should automatically insert it as not null
    attr_accessible :user_id
    belongs_to :user, class_name: "User"
end
