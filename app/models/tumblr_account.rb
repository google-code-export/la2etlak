class TumblrAccount < ActiveRecord::Base
  belongs_to :user, class_name: "User" 
  require 'tumblr'
  #CONSUMER_KEY  = 'QQQxBUYP17iv7ByUdfP1jNfuAoSBwA3NxMoH7jlvo3ImjjVCNU '
  #SECRET_KEY = 'XX8QVI0fUhU1j5v2nypLq67aCIkWBhA06bB19dYh42ahd6akdo'
  
 end