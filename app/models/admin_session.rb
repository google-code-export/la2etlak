class AdminSession < Authlogic::Session::Base 
# include Mongoid::Document
 def self.get_admin_current_session
  return AdminSession.find
 end
end
