require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
# Author : mostafa.amin93@gmail.com
  def setup
    @interest1 = Interest.create(:name => "The bored people", :description => "This interest is made specifically for the more bored people")
    @interest2 = Interest.create(:name => "Swarly Stinson", :description => "Please don't call me Swarely any more")
    @story1 = Story.new(:title => "more AWESOME pplz", :content => "Once upon a time I was a hero")
    @story1.interest=@interest1
    @story1.save
    @story2 = Story.new(:title => "Call me Barney", :content => "No more Swarrllleey, Swarl-ly, swarlz, NO MORE")
    @story2.interest=@interest2
    @story2.save
  end

  test "search title 1" do
    search_result = Admin.search_story("AwESomE!")
    assert(search_result.include? @story1)
  end

  test "search title 2" do
    search_result = Admin.search_story("pplz")
    assert(search_result.include? @story1)
  end

  test "search title 3" do
    search_result = Admin.search_story("Barney")
    assert(search_result.include? @story2)
  end

  test "search title 4" do
    search_result = Admin.search_story("Poland tomorrow")
    assert(search_result.empty?)
  end

  test "search content 1" do
    search_result = Admin.search_story("Swarlz")
    assert(search_result.include? @story2)
  end

  test "search content 2" do
    search_result = Admin.search_story("more")
    assert(((search_result.include? @story1) and (search_result.include? @story2)))
  end

  test "search interest name 1" do
    search_result = Admin.search_interest("StiNsoN")
    assert(search_result.include? @interest2)
  end

  test "search interest name 2" do
    search_result = Admin.search_interest("bored")
    assert(search_result.include? @interest1)
  end

  test "search interest description 1" do
    search_result = Admin.search_interest("swarely")
    assert(search_result.include? @interest2)
  end

  test "search interest description 2" do
    search_result = Admin.search_interest("elnesr")
    assert(search_result.empty?)
  end

  test "search interest description 3" do
    search_result = Admin.search_interest("more")
    assert(((search_result.include? @interest1) and (search_result.include? @interest2)))
  end
  
  test "search interest description 4" do
    search_result = Admin.search_interest("speciFIcally")
    assert(search_result.include? @interest1)
  end

#Author : mouaz.alabsawi@gmail.com

 test "should not save admin without email 1" do
   admin = Admin.new
   assert !admin.save
 end

 test "should not save admin with invalid email 2" do
   admin = Admin.new
   admin.email = "mouaz.alabsawi@gmail.com"
   admin.save
   assert_match(/\A(?:\w+\.)*\w+@(?:[a-z\d]+[.-])*[a-z\d]+\.[a-z\d]+\z/i, email, 'valid mail' ) 
 end

 test "should not save admin with password not confirmed 1" do
   admin = Admin.new
   admin.crypted_password = "adminp"
   admin.password_salt = "adminp"
   admin.save
   assert_equal( admin.crypted_password, admin.password_salt, 'password confirmed')
 end

 test "should not save admin with password length less than 4 chrachters 1" do
   admin = Admin.new
   admin.crypted_password = "adminp"
   admin.password_salt = "adminp"
   admin.save
   assert(admin.crypted_password.length > 3, 'password is short')
 end

 test "should not save admin with first and last name should be greater than  3 letters 1" do
   admin = Admin.new
   a.first_name = "admin"
   a.last_name = "admin"
   admin.save
   assert(admin.last_name.length > 3 && a.first_name.length > 3, 'first and last name is short')
 end


end
