class Admin
        #this is added for authlogic gem
    acts_as_authentic


	include Mongoid::Document
	field :first_name, type: String
	field :last_name, type: String
	field :email, type: String
	field :password, type: String
	field :password_confirmation, type: String
	belongs_to :interest_id
<<<<<<< HEAD
=======

  #attr_accessible :first_name, :last_name,:email, :password, :password_confirmation
 
 def send_forgot_password!
  deactivate!
  reset_perishable_token!
  Notifier.forgot_password(self).deliver
 end
  
require "net/http"
  $NAME = /([a-zA-Z]+)(.*)/
  $USERNAME = /(\w+)(.*)/
  $EMAIL = /((?:\w+\.)*\w+@(?:[a-z\d]+[.-])*[a-z\d]+\.[a-z\d]+)(.*)/
  $WORD = /(\w+)(.*)/
  $FULLNAME = /(\w+)\s+(\w+)(.*)/
>>>>>>> df966192cdaa5c71992d6b5d5be1160e562c610f

  #attr_accessible :first_name, :last_name,:email, :password, :password_confirmation
end
