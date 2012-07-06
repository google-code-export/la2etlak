require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  # test "the truth" do
  #   assert true
  # end

  #Author: Yahia
  test 'should be able to index friendships request' do
    u1 = users(:one)
    u2 = users(:two)
    u1.invite u2
    u2.approve u1    
    UserSession.create u1
  	get :index
  end 

  #Author: Yahia
  test 'should be able to create friendship' do  	
    u1 = users(:ben)
    u2 = users(:ahmed)
    UserSession.create u1
  	assert_difference('Friendship.count') do
  		get :create, {friend_id: u2.id}
      #, 'The count of Frienships should be changed'
  	end 
  end 

  #Author: Yahia
  test 'should be able to approve friendship' do  	
    u1 = users(:ben)
    u2 = users(:ahmed)
    u1.invite u2
    assert Friendship.find_by_user_id(1).nil?, 'Friendship shouldn\'t be nil' 
    UserSession.create u2
    assert u2.pending_invited_by.include?(u1), 'u2.pending_invited_by should include u1'
  	assert_difference('u1.friends.count') do
  		get :accept, {friend_id: u1.id}
  	end 
    assert u1.friends.include?(u2), 'u1.friends should include u2'
    assert u2.friends.include?(u1), 'u2.friends should include u1'
  end 

  #Author: Yahia
  test 'should be able to delete friendship' do  	
    u1 = users(:ben)
    u2 = users(:ahmed)
    u1.invite u2
    u2.approve u1    
    UserSession.create u1
  	assert_difference('u1.friends.count', -1) do
  		get :remove, {friend_id: u2.id}
  	end 
  end 


end
