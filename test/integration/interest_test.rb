require 'test_helper'

class InterestTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  setup :activate_authlogic

  ##########Author: Diab ############
  test "should route to all interests statistics" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
    assert_routing 'admins/statistics/all_interests', { :controller => "statistics", :action => "all_interests"}
  end


  ##########Author: Diab ############
  test "should route to interest statistics page" do
    admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
    AdminSession.create admin1
    assert_routing '/interests/statistics/1', { :controller => "statistics", :action => "interests" , :id => "1"}
   end 

  

  
end
