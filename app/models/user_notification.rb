class UserNotification < ActiveRecord::Base

	attr_accessible :owner, :user, :story, :comment, :notify_type, :new

end