require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  # Author: Yahia
  test "A user should be able to request a friendship of another user" do 
    u1 = User.first
    u2 = User.last
    assert u1.invite(u2), 'A user should be able to invite another user for friendship'
  end 

  # Author: Yahia
  test "A user should not be able to request the same friendhsip twice" do 
    u1 = User.first
    u2 = User.last
    u1.invite u2
    assert !u1.invite(u2), "A user should not be able to send two invitation to the same user"
  end 

  # Author: Yahia
  test "A user should be able to accept friendship requests" do 
    u1 = User.first
    u2 = User.last
    u1.invite u2
    assert u2.approve(u1), "A user should be able to approve friendship"
  end 

  # Author: Yahia
  test "A user should be able to remove frienship of another user" do 
    u1 = User.first
    u2 = User.last
    u1.invite u2
    u1.approve u2
    assert u1.remove_friendship(u2), "A user should be able to remove frienships"
    assert !u1.remove_friendship(u2), "A user should not be able to remove frienships that does not exists"
  end 

  # Author: Yahia
  test "A user should be able to see a list of his friends" do 
    u1 = User.first
    u2 = User.last
    u1.invite u2
    u2.approve u1
    assert_equal u1.friends.first.class.name, 'User', "user.friends should return a list of Users"
  end 

end
