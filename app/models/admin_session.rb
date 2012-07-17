class AdminSession < Authlogic::Session::Base 

 def self.get_admin_current_session
  return AdminSession.find
 end
end
