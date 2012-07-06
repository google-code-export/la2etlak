require 'test_helper'

class InterestTest < ActiveSupport::TestCase
 

  # test "the truth" do
  #   assert true
  # end

  ##########Author: Diab ############
  def setup
    Interest.destroy_all
  end

  ##########Author: Diab ############
  test "is rank updated after user added interest" do
     interest = Interest.new(:name=>"whatever")
     interest.save
     user = User.new(:email=>"email@mail.com" , password: "12345678",password_confirmation:"12345678")
     user.save
     rank = interest.get_interest_rank
     user.added_interests << interest
     assert_difference('rank' , 5) do
     rank = interest.get_interest_rank
     end
    end

  ##########Author: Diab ############
  test "is rank updated after story added to interest" do
     interest = Interest.new(:name=>"whatever")
     interest.save
     rank = interest.get_interest_rank
     story = Story.new(:title=>"Story")
     story.interest = interest
     story.save
     assert_difference('rank' , 2) do
     rank = interest.get_interest_rank
     end
    end
  
  
  ##########Author: Diab ############
  test "top interests" do
     interest1 = Interest.new(:name=>"whatever1")
     interest1.save
     interest2 = Interest.new(:name=>"whatever2")
     interest2.save
     interest3 = Interest.new(:name=>"whatever3")
     interest3.save
     user = User.new(:email=>"email@mail.com", password: "12345678",password_confirmation:"12345678")
     user.save
     story1 = Story.new(:title=>"Story")
     story1.interest = interest2
     story1.save
     story2 = Story.new(:title=>"Story")
     story2.interest = interest3
     story2.save
     user.added_interests << interest1
     user.added_interests << interest3
     top_interests_names = Interest.get_top_interests_names
     top_interests_ranks = Interest.get_top_interests_ranks
     assert_equal top_interests_names , ["whatever3","whatever1","whatever2"]
     assert_equal top_interests_ranks , [7,5,2]
    end

  ##########Author: Diab ############
  test "are all users added interest returned" do
     interest = Interest.new(:name=>"whatever")
     interest.save
     user1 = User.new(:email=>"email1@mail.com",password: "123456782",password_confirmation:"123456782")
     user1.save
     user1.added_interests << interest
     user2 = User.new(:email=>"email2@mail.com" , password: "12345678",password_confirmation:"12345678")
     user2.save
     user2.added_interests << interest
     allUsers = interest.get_users_added_interest
     assert_equal allUsers , interest.adding_users
    end





#Author:Jailan
 test "should save interest when updated " do
    interest = Interest.create!(name: "my Test", description: "blabla")
     @inty = Interest.model_update( interest.id ,{ :name => "fff" } )

    assert interest.save , "Interest wasn't saved when updated"
 
end

  test "no interest without name "do
    interest = Interest.new
    assert !interest.save, "Should not save without name"
  end

#Author:Jailan
 test "shouldn't update interest when name is blank" do
 interest = Interest.create!(name: "my Test", description: "blabla")
 interest.name=""

 assert !interest.save ," Cannot save an Interest with a blank Name"

  end




#Author:Jailan
 test "should save interest when toggled " do
    interest = Interest.create!(name: "my Test", description: "blabla")
    @inty = Interest.model_toggle(interest.id)

    assert interest.save , "Interest wasn't saved when toggled"
  end







end
