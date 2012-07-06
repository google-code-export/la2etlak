class TumblrAccount < ActiveRecord::Base
  belongs_to :user, class_name: "User" 
  require 'tumblr'
  #CONSUMER_KEY  = 'QQQxBUYP17iv7ByUdfP1jNfuAoSBwA3NxMoH7jlvo3ImjjVCNU '
  #SECRET_KEY = 'XX8QVI0fUhU1j5v2nypLq67aCIkWBhA06bB19dYh42ahd6akdo'
  
  #get_feed issue 90
=begin
     gets user tumblr feeds
     a gem is used called matenia-tumblr-api
     the user enters his email and password in the login.html.view,
     values are added to the tumbr account model and saved
     when get_feed is called the authentication is done through the first line
     then blog name is get
     finally looping and converting blogs into stories
   Input: no input  
   Output: list of stories
   Author: Essam Hafez
=end
  
  def get_feed
    begin
      new_tumblr = Tumblr::User.new(self.email, self.password) #Authentication
      blog = new_tumblr.tumblr["tumblelog"]["name"]   #Get blog name through hashes
      Tumblr.blog = blog # set blog name
      stories = Array.new # create stories array to be returned
      posts = Tumblr::Post.all #Get user posts
      posts.each do |post| #loop and convert to story type
        s = TumblrAccount.convert_blog_to_story(post)
        if(!(s.content == ""))
          stories.push(s) #adds element to list
        end
      end
      stories #returned
    rescue
      raise
      return []
    end
  end
  

=begin
  #gets a blog and grabs out the needed content from it to fit our application
  #a story needs a title, content and media link
  input: blog from tumblr
  output: story
  Author: Essam Hafez
=end  
  def self.convert_blog_to_story(post)
    story = Story.new #new Story
    #story.instance_variables
    story.category = 'tumblr' #sets story category to tumblr
    post_type = post["type"] # get post type
    if(post_type == "photo") # story is a photo
      photo_type = post["photo_url"] #Grabs required parameters 
      story.media_link = post["photo_url"][3]["__content__"] #gets photo @ position 3 with max width of 250px
      story.content = post["photo_caption"] # get caption in case phoro can be loaded
      story.content = story.content.gsub(/<\/?[^>]+>/, '')
      story.title = post["slug"] # title encapsulated into "slug" hash
      story.title = story.title.gsub(/<\/?[^>]+>/, '')
    elsif(post_type == "regular")
      story.content = post["regular_body"] #story body encapsulated in regular body
      story.content = story.content.gsub(/<\/?[^>]+>/, '')
      story.title = post["slug"] # title encapsulated into "slug" hash
      story.title = story.title.gsub(/<\/?[^>]+>/, '')
    else
      story.content = ""
    end
    return story
  end
end
