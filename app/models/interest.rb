class Interest < ActiveRecord::Base
#Author: jailan ---------- Mongo-----------


  include Mongoid::Document
  include Mongoid::Timestamps

  #Fields:

  field :name, type: String
  field :description, type: String
  field :deleted, type: Boolean
  #field :photo, type: String

 
  attr_accessible :description, :name, :deleted, :photo  
  has_many :stories
  has_many :feeds, :dependent => :destroy

#the attached file we migrated with the interest to upload the interest's image from the Admin's computer
  #has_attached_file :photo, :styles => { :small => "150x150>" },
                    #:url  => "/assets/products/:id/:style/:basename.:extension",
                    #:path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"
#here we validate the an Image should be specified with a certain size & type
#validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

 # RSS feed link has to be of the form "http://www.abc.com"
  LINK_regex = /^(?:(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(?::[0-9]{1,5})?(\/.*)?)|(?:^$)$/ix
 
  # name cannot be duplicated and has to be there .

  validates :name, presence: true, uniqueness: {case_sensitive: false},length:{ maximum: 20 }

                 

  has_many :block_interests
  has_many :blockers, class_name: "User", :through => :block_interests
  has_many :user_add_interests
  has_many :adding_users, class_name:"User", :through => :user_add_interests

#description can never exceed 240 characters .
  validates :description,  length: { maximum: 100 }

  
end