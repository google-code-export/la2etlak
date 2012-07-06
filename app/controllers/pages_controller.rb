class PagesController < ApplicationController

  def home
    @title = "Home"
    @feed = Feed.new 
  end


end
