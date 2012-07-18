class FacebookAccount < ActiveRecord::Base

  field :user_id, type: Integer
  field :facebook_id, type: Integer
  field :auth_token, type: String
  field :auth_secret, type: String
  #field :created_at, type: datetime 
  #field :created_at, type: datetime 
  #Since I added the timestamps we dont need them 


  attr_accessible :auth_secret, :auth_token

  belongs_to :user
  validates_presence_of :user
  validates_presence_of :auth_token
  validates_presence_of :auth_secret

end