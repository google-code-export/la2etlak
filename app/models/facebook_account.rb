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
      new_token = Koala::Facebook::OAuth.new('http://localhost:3000').exchange_access_token(self.auth_token.to_s)
      self.auth_token = new_token.to_s
      self.auth_secret = self.auth_secret.to_i+1
      self.save!
      graph = Koala::Facebook::API.new(new_token)
      g = graph.get_connections("me","home")
      #$facebook_pp	= graph.get_object(current_user.facebook_account.facebook_id)["picture"]
      feed = Array.new
      pic = ""
      content = ""
      media = ""
      # p g.nil?

puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

g.each do |x|
  if x["type"] == "status"
   # puts x

    i = x["id"]
    puts i
    userid = i.split('_')[0]
    storyid = i.split('_')[1]
    puts userid
    puts storyid

    puts "http://www.facebook.com/#{userid}/posts/#{storyid}"

  end
end

puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"



      if g
        i = 0
        g.each do |s| 
          i = i+1
          id  = s["id"]
          # p i.to_s
          # p s["type"]
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
            if s["link"]
              story_link = s["link"]
            elsif s["source"]
              story_link = s["source"]
            else
              next
            end
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

            elsif s["type"] == "status"
            title = s["from"]["name"]+" changed his"+" status:\n"
            msg = ""
            msg = s["message"] if s["message"]
            if msg.length > 150
              content = msg + "\n"
              msg = msg[0,150]+"..."
            end
            title = title+"\n"+msg
            media = "http://graph.facebook.com/#{s["from"]["id"]}/picture"
            user_id = s["id"].split('_')[0]
            story_id = s["id"].split('_')[1]
            story_link = "http://www.facebook.com/#{user_id}/posts/#{story_id}"
            if s["caption"]
              content = content + s["caption"]
            end
          else
            next
          end
          # create new story with the attributes
          # that were fetched
          story = Story.new
          if title.length > 500
            title = title[0,500]+"..."
          end
          if content.length > 500
            content = content[0,500]+"..."
          end
          story.mobile_content = id
          story.id = id
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
      #self.destroy
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

  def fb_comment(post_id, content)
    graph = Koala::Facebook::API.new(self.auth_token.to_s)
    graph.put_connections(post_id, "comments", :message => content)
  end

  def fb_delete_comment(post_id)
    graph = Koala::Facebook::API.new(self.auth_token.to_s)
    graph.delete_object(post_id)
  end

  def fb_like(post_id)
    graph = Koala::Facebook::API.new(self.auth_token.to_s)
    graph.put_connections(post_id, "likes")
  end

  def fb_dislike(post_id)
    graph = Koala::Facebook::API.new(self.auth_token.to_s)
    graph.delete_like(post_id)
  end

  def fb_get_comments(post_id)
      graph = Koala::Facebook::API.new(self.auth_token.to_s)
      comments_hash = graph.get_connection(post_id,"comments")
      comments = Comment.new
      comments_array = Array.new
      comments_hash.each do |c|
         comments.id = c["id"]
         comments.user_id = c["from"]["id"]
         #c["from"]["name"]
         comments.story_id = post_id
         comments.content = c["message"]
         comments_array.push(comments)
      end
      return comments_array
  end

def test 
  c = self.fb_comment("1259868446_4387718092004", "ya rab")
  g = self.fb_get_comments("1259868446_4387718092004")
  puts c["id"]
  puts g.last["id"]

end


#1259868446_4387718092004
#test
#http://www.facebook.com/1259868446/posts/4387718092004





end
