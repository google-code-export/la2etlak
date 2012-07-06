require 'flickraw'

class FlickrAccount < ActiveRecord::Base

  API_KEY='443b0e6f88e26df854bdf0d7f7a8c1d5'
  SHARED_SECRET='ff3e3ebe8f31e039'
  

=begin  
  consumer_key and secret_key are the access keys to the flickr 
  accounts. Flickr provides them to us in phase to in the 
  authentication. see flickr_accounts_controller.rb for more info 
=end

  attr_accessible :consumer_key, :secret_key
  belongs_to :user, class_name: "User" 

  validates :consumer_key, presence: true
  validates :secret_key, presence: true
  validates :user_id, presence: true 
  validates :user_id, uniqueness: true

=begin
 Description:
 This is the configuaration for the gem. Its called every time I need an access to the flickr account
 of the user.
 Input: NO
 Output: NO
 Author : 3OBAD
=end

  def config_flickr
   FlickRaw.api_key=API_KEY
   FlickRaw.shared_secret=SHARED_SECRET
   flickr.access_token=self.consumer_key
   flickr.access_secret=self.secret_key
  end


=begin
Description
  This is the method responsible for getting the recent photos of the user`s 
  friends. login = flickr.test.login is used to chech the if the token has expired 
  or not by making a test login. photo_list is a list of the recent friends` photos
  then we change them into stories to be used in the main feed.

Input: count - No of photos to return
Output: List of stories

Author: 3OBAD
=end


  def get_feed(count=20)

    begin
      self.config_flickr
      login = flickr.test.login
      user = flickr.people.findByUsername( :username => login.username )
      photo_list=flickr.photos.getContactsPhotos(:count=>count.to_s)
      stories = Array.new
      photo_list.each do |photo|
        temp = FlickrAccount.convert_photo_to_story(photo) 
        stories.push(temp) 
      end 
    rescue Exception => ex
      puts ex
      return []
    end
      stories
  end


=begin
Description:
  This is the method that change the photo into a story by getting 
  the story url and its title. The story is made as C1 requested.
Input: photo -  Photo retrieved from flickr
Output:Story
Author: 3OBAD
=end 

  def self.convert_photo_to_story(photo)
    story = Story.new
    info = flickr.photos.getInfo :photo_id => photo.id, :secret => photo.secret
    original_url = FlickRaw.url(info)
    story.instance_variables
    story.title = info.title
    story.category = 'flickr'
    story.content = info.description
    story.media_link = original_url
    return story 
  end

end