require 'flickraw'

class FlickrAccount < ActiveRecord::Base

  include Mongoid::Document
  include Mongoid::Timestamps

  API_KEY='443b0e6f88e26df854bdf0d7f7a8c1d5'
  SHARED_SECRET='ff3e3ebe8f31e039'
  

=begin  
  consumer_key and secret_key are the access keys to the flickr 
  accounts. Flickr provides them to us in phase to in the 
  authentication. see flickr_accounts_controller.rb for more info 
=end


  field :user_id, type: Integer
  field :consumer_key, type: String
  field :secret_key, type: String
  #field :created_at, type: datetime 
  #field :created_at, type: datetime 
  #Since I added the timestamps we dont need them 


  attr_accessible :consumer_key, :secret_key
  belongs_to :user, class_name: "User" 

  validates :consumer_key, presence: true
  validates :secret_key, presence: true
  validates :user_id, presence: true 
  validates :user_id, uniqueness: true
end