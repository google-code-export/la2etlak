class AdminSession < Authlogic::Session::Base 
# include Mongoid::Document
<<<<<<< HEAD
=======
 def self.get_admin_current_session
  return AdminSession.find
 end
>>>>>>> df966192cdaa5c71992d6b5d5be1160e562c610f
end
