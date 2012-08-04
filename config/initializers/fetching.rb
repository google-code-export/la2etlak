require 'rubygems'
require 'rufus/scheduler'
require 'stories_helper'
require 'chronic'

  scheduler = Rufus::Scheduler.start_new
  #scheduler.every '24h', :first_at => Chronic.parse('today 23:59') do
  scheduler.every '3h' do
    #Author: Gasser
    #Increment the $loksha before each fetch for the feeds in the system
    $loksha = $loksha + 1
  	puts '%%%%%%%%%%%%%%% FETCHING NEW RSS '+ "#{$loksha}" +'%%%%%%%%%%%%%%%%%%'
    Interest.all.each do |interest|
      if interest.deleted.nil?
        interest.feeds.each do |feed|
          begin
            StoriesHelper.fetch_rss(feed.link)
          rescue
            puts "FETCHING of #{interest} IGNORED BECAUSE OF AN EXCEPTION"
          end 
        end
      end
    end
    puts '%%%%%%%%%%%%%%% FETCHING NEW RSS END %%%%%%%%%%%%%%'
  end
