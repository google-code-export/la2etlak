 require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest 

test "should route to login page" do
  assert_routing '/admin/login', { :controller => "admin_sessions", :action => "new"}
    end
  test "should route to logout" do
  assert_routing '/admin/logout', { :controller => "admin_sessions", :action => "destroy"}
    end
  test "should route to reset password" do
  assert_routing '/password_resets/new', { :controller => "password_resets", :action => "new"}
    end

end
