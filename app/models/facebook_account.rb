

class FacebookAccount < ActiveRecord::Base
  attr_accessible :auth_secret, :auth_token
  belongs_to :user
  validates_presence_of :user
  validates_presence_of :auth_token
  validates_presence_of :auth_secret

=begin
   Method to get facebook feed of the user
   if the token is expired a new one is generated
   using koala's helper exchange token method 
   key attributes are selected from the facebook stream
   according to the story type
   Inputs: none
   Output: story array of facebook images and videos
	 Author: Menisy
=end
  def get_feed
  	begin
      self.auth_secret = self.auth_secret.to_i+1
      new_token = Koala::Facebook::OAuth.new("http:\\127.0.0.1:3000").exchange_access_token(self.auth_token.to_s)
      self.auth_token = new_token.to_s
      self.auth_secret = self.auth_secret.to_i+1
      self.save!
      graph = Koala::Facebook::API.new(new_token)
      g = graph.get_connections("me","home")
      feed = Array.new
      pic = ""
      content = ""
      media = ""
      p g.nil?
      if g
        i = 0
        g.each do |s| 
          i = i+1
          p i.to_s
          p s["type"]
          title = s["from"]["name"]+" shared "
          # check on the type of post
          if s["type"] == "photo"
            title = title+"a photo:\n"
            msg = ""
            msg = s["message"] if s["message"]
            if msg.length > 150
              content = msg + "\n"
              msg = msg[0,150]+"..."
            end
            title = title+"\n"+msg
            media = s["picture"]
            story_link = s["link"]
            if s["caption"]
              content = content + s["caption"]
            end
          elsif s["type"] == "video"
            title = title+"a video:\n"
            title = title+"\n"+s["name"] if s["name"]
            story_link = s["link"]
            img = s["picture"]
            if img
              if img.index("url=")
                # extract video url from within the link
                img_link = URI.unescape(img[img.index("url=")+4,img.length])
              else
                img_link = img
              end
            else
              img_link = ""
            end
            media = img_link
            content = s["message"] if s["message"]
            content = content + s["description"] if s["description"]
          else
            next
          end
          # create new story with the attributes
          # that were fetched
          story = Story.new
          story.title = title
          story.media_link = media
          story.story_link = story_link
          story.content = content
          story.deleted = false
          story.hidden = false
          story.category = "Facebook"
          feed.append story
          pic = ""
          story_link = ""
          content = ""
          media = ""
        end
        return feed
      end	
    rescue
      self.destroy
      return []
    end
  end

=begin
  Adds the log message whenever a user
  connects his/her facebook account
  Inputs: none
  Output: none
  Author: Menisy
=end  
  def add_to_log
    user_name = self.user.name  ||  self.user.email.split('@')[0]
    Log.create!(loggingtype: 2,user_id_1: self.user.id ,user_id_2: nil,admin_id: nil,story_id: nil ,interest_id: nil,message: (user_name+" added a Facebook account").to_s)
  end
end
