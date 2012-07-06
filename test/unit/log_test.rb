require 'test_helper'
require 'chronic'

class LogTest < ActiveSupport::TestCase
  #Author : MESAI
   test "should get the recent activity of certain user" do
     User.create!(name: "dummy", email: "dummy@dummy.com", password:"123456", password_confirmation: "123456")
     Log.create!(loggingtype: 0,user_id_1: 1,user_id_2: nil,admin_id: nil,story_id: nil ,interest_id: nil ,message: "")    
     assert_equal(Log.get_log_for_user(1,Time.zone.now).count ,1)
   end
  
end