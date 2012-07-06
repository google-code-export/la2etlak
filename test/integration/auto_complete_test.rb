require 'test_helper'
#Author MESAI
class AutoCompleteTest < ActionDispatch::IntegrationTest
  setup do
        @admin1 = Admin.create!(email:"admin1@gmail.com", password:"123456", password_confirmation:"123456")
        post '/admin/login', :admin_session => {:email => 'admin1@gmail.com', :password => '123456'}
      end
  #this test is to make sure that the route of auto complete is not lost 
  test "AutoCompleteRoute" do
     post 'autocomplete/auto_complete_for_autocomplete_query', {:controller =>"autocomplete" , :action => "auto_complete_for_autocomplete_query",:autocomplete=>{:query =>""}}
  end
   #this test is to make sure that the auto completion really works
   test "Admin should get result from the AutoCompletion" do
   	  get "/admins/index"
      User.create!(name: "dummy0", email: "dummy0@gmail.com", password:"123456" , password_confirmation: "123456")
      post 'autocomplete/auto_complete_for_autocomplete_query', {:controller =>"autocomplete" , :action => "auto_complete_for_autocomplete_query",:autocomplete=>{:query =>"d"}}
      @response.content_type = 'text/html'
      assert_tag :tag =>"ul" , :child => {:tag => "li", :content =>"dummy0"}
    end
end
