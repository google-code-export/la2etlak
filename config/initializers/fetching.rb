require 'rubygems'
require 'rufus/scheduler'
require 'stories_helper'
require 'chronic'

  scheduler = Rufus::Scheduler.start_new
  scheduler.every '24h', :first_at => Chronic.parse('today 23:59') do
    Interest.all.each do |interest| 
      interest.feeds.each do |feed|
        StoriesHelper.fetch_rss(feed.link)
      end
    end
  end