module StoriesHelper
 
=begin
Discription : this method takes as a parameter the html file and extract the content from it 
Input : String
Output : String
Author: Omar
=end

require 'nokogiri'
require 'rubygems'
require 'open-uri'
 def new_content(sdescription)

	doc = Nokogiri::HTML(sdescription)
	doc = doc.xpath("//text()").to_s
	
	return doc

 end
 '''
  This method gets the number of a certain activity (shares, likes, dislikes, 
  flags) of a certain story using its id in each day in the last 30 days.
  There are several cases, concerning the date of creation, last update and
  hiding of the story, that has to handeled:
  1) If the story was created and hidden within the last 30 days, then I only 
  return the activity from the table between the creation date and the last 
  update which is the hiding.
  2) If the story was created before the last 30 days and hidden within the last
  30 days, then I only return the activity from the table between the last 30 
  days and the last update which is the hiding.
  3) If the story was created and hidden before the last 30 days, then I will 
  return an empty array.
  4) If the story was not hidden and it was created before the last 30 days, 
  then I return the activity from the table between the last 30 days and the 
  current date.
  5) If the story was not hidden and it was created within the last 30 days, 
  then I return the activity from the table between the creation date of the 
  story and the current date.
  '''
  def get_no_of_activity(needed_graph, creation_date, last_update, hidden)
    activities_by_day=[]
    if hidden && creation_date >= 30.days.ago.to_date && 
       last_update >= 30.days.ago.to_date
        days= (Time.zone.now.to_date - creation_date.to_date).to_i
        days2= (Time.zone.now.to_date - last_update.to_date).to_i
        (days.downto(days2)).each do |i|
            activities_by_day<<needed_graph.where(:created_at=> i.days.ago.beginning_of_day..i.days.ago.end_of_day).count
           end
          return activities_by_day
      
    elsif hidden && creation_date < 30.days.ago.to_date && 
          last_update >= 30.days.ago.to_date
          days= (Time.zone.now.to_date - last_update.to_date).to_i
          (30.downto(days)).each do |i|
            activities_by_day<<needed_graph.where(:created_at=> i.days.ago.beginning_of_day..i.days.ago.end_of_day).count
           end
          return activities_by_day
      
    elsif hidden && creation_date < 30.days.ago.to_date && 
          last_update < 30.days.ago.to_date
      activities_by_day = []
      
    elsif creation_date < 30.days.ago.to_date
      (30.downto(0)).each do |i|
        activities_by_day<<needed_graph.where(:created_at=> i.days.ago.beginning_of_day..i.days.ago.end_of_day).count
       end
       return activities_by_day
    else
      days= (Time.zone.now.to_date - creation_date.to_date).to_i
      (days.downto(0)).each do |i|
        activities_by_day<<needed_graph.where(:created_at=> i.days.ago.beginning_of_day..i.days.ago.end_of_day).count
       end
       return activities_by_day
    end
  end
 
=begin
Discription : this method takes as a parameter the html file and extract the img src (url) from it 
Input : String
Output : String
Author: Omar
=end
 
require 'nokogiri'
require 'rubygems'
require 'open-uri'
  def  new_media_link(sdescription)
 
	frag = Nokogiri::HTML.fragment(sdescription)
	if !frag.at_css('img').nil?
	first_img_src = frag.at_css('img')['src']
	#first_p_text  = frag.at_css('p').text
 				url_end = ".com" 
 				if first_img_src.length > 1
				  allstart = first_img_src.index(url_end)
				  media = first_img_src[ allstart.to_i+4 , first_img_src.length ] 
			        end
			 dot = "." 
			 m = media.index(dot) 
			
		 if !m.nil? 
	 return first_img_src
	 	else 
	 	 return ""
	 	  end
	 else 
	   return ""
	 end  
	
 end
 

 
 
  
  
  '''
  This method returns the percentage of the likes to the total number 
  of likes and dislikes
  '''
  def get_width
    likes =  @story.likedislikes.where(action: 1).count
    dislikes =  @story.likedislikes.where(action: -1).count
    total = likes + dislikes
    if total == 0
      width = 0
    else 
      width = likes*100/total
    end
  end

#the method of fetching rss feeds

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
#Author: Gasser
#Initialize the global variable loksha for the balue in the column loksha_id in the story model.
$loksha = 1

def fetch_rss(link)

  #source = "http://feeds.abcnews.com/abcnews/topstories" # url or local file
  source = link
  content = "" # raw content of rss feed will be loaded here

  #parsing the url
  open(source) do |s| content = s.read end
  rss = RSS::Parser.parse(content, false)


  i = 0
  num = rss.items.size
  #creating the array of stories
  listOfStories = Array.new()

  scategory = rss.channel.link

  #creating the stories and put them in the array
  while i < num do

    stitle = rss.items[i].title
    sdate = rss.items[i].date
    sdescription =  rss.items[i].description
    slink = rss.items[i].link

    #check if the story already exists in the database
    #count_of_stories_with_same_title = Story.where(:title => stitle).select("count(title)")
    sid = Story.find_by_story_link(slink)

    #if it is a new story, it will enter automatically
    #if count_of_stories_with_same_title == 0
      #getting the id of the interest 
	#f = Feed.find_by_link(source)
	
	#if f == nil
	#	f = Feed.new(:interest_id => 1)
	#	f.link = source
	#	f.save
	#end

	#getting the id of the interest
      
	sinterest = Feed.find_by_link(source).interest
  sfeed = Feed.find_by_link(source)

    #if it is a new story, it will enter automatically
    if sid == nil
    puts '#######################################################1'
     i = 0
 
      storynow = Story.new(:title => stitle, :rank => 0, :category => "RSS", :deleted => false, :hidden => false, :media_link => "")
	

    puts '######################################################2'
      storynow.interest = sinterest
      storynow.content = sdescription
      storynow.story_link = slink
      #img = "img src="
      #if(sdescription.index(img) != 0)
      storynow.media_link =  storynow.new_media_link(sdescription)	
      #end
      storynow.mobile_content = storynow.new_content(sdescription)
      # if storynow.mobile_content.include? "read more"
      #   storynow.mobile_content["read more"] = " <a href= storynow.link> read more</a>"
      # else
      #   storynow.mobile_content = storynow.mobile_content + " <a href= storynow.link> see the original story</a>"
      # end
      if sfeed.first_tag == nil || sfeed.end_tag = nil || sfeed.first_tag.last != ">" || sfeed.end_tag.last != ">" || sfeed.first_tag.first != "<" || sfeed.end_tag.first != "<"
        storynow.content = sdescription
        storynow.mobile_content = storynow.new_content(sdescription)
      else
        feed_first_tag = sfeed.first_tag
        feed_end_tag = sfeed.end_tag
        # result_from = StoriesHelper.get_full_content(slink,feed_first_tag,feed_end_tag)
        # if result_from == "emptyuu" || result_from.length < sdescription.length
        #   storynow.content = sdescription
        #   storynow.mobile_content = storynow.new_content(sdescription)
        # else
        #    p story_link
        #    p result_from
        #   storynow.content = result_from
        #   storynow.mobile_content = storynow.new_content(result_from)
        # end
        response = ""
        require 'open-uri'

        url = URI.parse(storynow.story_link)
        open(url) do |http|
        response = http.read
      end
        want = response.match(/#{feed_first_tag}(.*)#{feed_end_tag}/m)
        new_contentoz = $1
                if new_contentoz == nil || new_contentoz.length < sdescription.length
                      storynow.content = sdescription
                      storynow.mobile_content = storynow.new_content(sdescription)
                else
                       storynow.content = new_contentoz
              storynow.mobile_content = storynow.new_content(new_contentoz)
        end

      end

      #Author: Gasser
      #to add the current loksha_id to this new story.
      storynow.loksha_id = $loksha
      storynow.rss_feed = link
      storynow.save

      #Ranking by:Diab#
      int = Interest.find(sinterest)
      int.rank = int.rank + 1
      int.save
      #Ranking by:Diab#

      sid = Story.find_by_title(stitle).id
      
      Log.create(loggingtype: 2,story_id: sid,message: "new story")

      listOfStories.append(storynow)
      i+=1
    else
      puts '#######################################################3'
      #if the story exists in the database it will enter the array without modifications

      storynow = Story.find_by_title(stitle)
      listOfStories.append(storynow)
    end
      i+=1

    if i == num || i ==50
      #if the array is full, return it
      return listOfStories
    end
end

#handling the errors of the links are not valid
rescue OpenURI::HTTPError
	return false
rescue SocketError
	return false
rescue RuntimeError
	return false
#rescue NoMethodError
#	p 'enter valid link not a website'
#	return false
rescue Errno::ENOENT
	p 'enter valid link'
	 return
rescue RSS::NotWellFormedError
	p 'enter valid rss feed link form'
	return false
end

def check_rss(link)

  source = link
  content = "" # raw content of rss feed will be loaded here

  #parsing the url
  open(source) do |s| content = s.read end
  rss = RSS::Parser.parse(content, false)
  scategory = rss.channel.link
  return true

  rescue OpenURI::HTTPError
  return false
  rescue SocketError
  return false
  rescue RuntimeError
  return false
  rescue NoMethodError
  p 'enter valid link not a website'
  return false
  rescue Errno::ENOENT
  p 'enter valid link'
   return false
  rescue RSS::NotWellFormedError
  p 'enter valid rss feed link form'
  return false


  return false
end

=begin
author : mouaaaaaaaaaaz
this method take the link of a certain story and the limits
of a certain tag wich belongs to certain feed and get the full content in this tag
=end

def get_full_content(story_link, match1, match2)
  # require 'open-uri'
  # source = open(story_link).read

#   require 'net/http'
#   rss_link["http://www."] = ""
#   # rss_link["http://"] = ""
# stack = Net::HTTP.new rss_link
# p stack
# page = story_link
# page["http://www." + rss_link] = ""
# p page
# html = stack.get(page).body
# return html
response = ""
  require 'open-uri'

  url = URI.parse(story_link)
  open(url) do |http|
    response = http.read

    returno = StoriesHelper.substring_between(response,match1,match2)
    if returno == nil
      returno = "emptyuu"
      return returno
    else
      return returno
    end

    # puts "response: #{response.inspect}"
      # if response =~ regex
      #   return $1
      # else
      #   return false
      # end
  end
  # StoriesHelper.get_full_content('http://www.yallakora.com//arabic/YK_news/details.aspx?ID=191740&amp;ref=rss&amp;updated=182012240',/<div id="" class="bodycontent">(.*)<\/div>/)
  rescue OpenURI::HTTPError
  return false
  rescue SocketError
  return false
  rescue RuntimeError
  return false
end

def substring_between(target, match1, match2)
  start_match1 = target.index(match1)
  if start_match1 && start_match2 = target.index(match2, start_match1 + match1.length)
    start_idx = start_match1 + match1.length
    target[start_idx, start_match2 - start_idx]
  else
    nil
  end
end

module_function :substring_between
module_function :get_full_content
module_function :fetch_rss
module_function :check_rss
end
