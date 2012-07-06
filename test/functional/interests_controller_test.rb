require 'test_helper'

class InterestsControllerTest < ActionController::TestCase

setup :activate_authlogic
  #Author Jailan
  #checking route is not lost 
  test "Interest main page routes" do
     interest = Interest.first
     get :show, :id => interest.id
     assert_routing '/interests/'+interest.id.to_s, {:controller =>"interests", :action => "show", :id=> "1"}
    end

  #Author Jailan
  #this test is to make sure that the main page does exist and i get a 200OK response     
  test "Interest Main Page" do
      myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
     AdminSession.create myadmin 
       get :show, :id => 1
      assert_response :success , "rout is not correct"
    end

 

#Author: Jailan
test "should update Interest" do
      myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
     AdminSession.create myadmin 
  put :update, :id => interests(:two), :interest => {:name => 'MyString2'}
 assert_equal "MyString2", Interest.find(interests(:two).id).name , "should update"
end

#Author: Jailan
test "shouldn't update Interest with a blank name " do
      myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
     AdminSession.create myadmin 
  put :update, :id => interests(:one), :interest => {:description => 'lala'}
 assert_not_equal "lala", Interest.find(interests(:one).id).name , "shouldn't update"
end

#Author: Jailan
test "shouldn't update Interest when it's blocked " do
      myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
     AdminSession.create myadmin 
  put :toggle, :id => interests(:two), :interest => {:deleted => true}
  assert_equal true, assigns(:interest).deleted
  put :update, :id => interests(:two), :interest => {:name => 'lala'}

 assert_not_equal "lala", Interest.find(interests(:two).id).name , "it's blocked , never update"
end




#Author:Jailan
  test "should block interest " do
      myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
     AdminSession.create myadmin 
  put :toggle, :id => interests(:two), :interest => {:deleted => true}
  assert_equal true, assigns(:interest).deleted , "should be blocked"
end

#Author:Jailan
test "should restore interest" do
  myadmin = Admin.create(email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
 
  AdminSession.create (myadmin)
  
  put :toggle, :id => interests(:one), :interest => {:deleted => nil}
  assert_equal nil, assigns(:interest).deleted , "should be restored"

end



#Author:Jailan

 test "should have restore button when blocked" do
   myadmin = Admin.create(email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")

  AdminSession.create (myadmin)
 put :toggle, :id => 2, :interest => {:deleted => false}

 get :show, :id => 2
assert_select 'div[id = "restore"]'
end
#Author:Jailan
test "should have block button when not blocked" do
 myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
 AdminSession.create myadmin 
 put :toggle, :id => 1, :interest => {:deleted => true}
 get :show, :id => 1
assert_select 'div[id = "block"]' 

end

#Author:Jailan
  test "should have an update form to fill with save changes button" do
     myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
     AdminSession.create myadmin 
     get :show, :id => 1
    assert_select 'div[id = "update"]' 

  end

#Author:Jailan
  test "should have a status form showing the Interests Status" do
     myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
     AdminSession.create myadmin 
     get :show, :id => 1
    assert_select 'div[id = "status"]' 

  end


#Author:Jailan "Testing the browse plugin"
  test "should have an image saved  after creating" do
     myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
     AdminSession.create myadmin 
     get :show, :id => 1
    assert_select 'div[id = "image"]'

  end

#Author:Jailan
test "should see the correct Flash message when restored" do
  myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
  AdminSession.create myadmin 
  put :toggle, :id => interests(:one), :interest => {:deleted => nil}

  assert_equal " Interest restored successfully $green", flash[:success]
end

#Author: Jailan
test "Flash success when update Interest" do
  myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
  AdminSession.create myadmin 
  put :update, :id => interests(:two), :interest => {:name => 'MyString2'}
  assert_equal " Changes saved successfully $green", flash[:success]
end

#Author: Jailan
test "Flash error when update Interest with a blank name " do
  myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
  AdminSession.create myadmin 
  put :update, :id => interests(:two), :interest => {:name => "", :description => 'lala'}
  assert_equal "  Interest update failed: Name can't be blank $red", flash[:error]
end

#Author: Jailan
test " Flash Error shouldn't update Interest when it's blocked " do
  myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
  AdminSession.create myadmin 
  put :toggle, :id => interests(:two), :interest => {:deleted => true}
  assert_equal true, assigns(:interest).deleted
  put :update, :id => interests(:two), :interest => {:name => 'lala'}

  assert_equal " This interest is now blocked, please restore it if you want to update $red", flash[:error]
end




#Author:Jailan
  test "flash success when block interest " do
  myadmin = Admin.create( email:"jolly@mail.com" , password:"123456" , password_confirmation: "123456")
  AdminSession.create myadmin 
  put :toggle, :id => interests(:two), :interest => {:deleted => true}
 
  assert_equal " You have just blocked this interest $red", flash[:error]
end




end
