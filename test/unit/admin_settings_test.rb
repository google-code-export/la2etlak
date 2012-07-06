require 'test_helper'

class Admin_SettingsTest < ActiveSupport::TestCase
  
  def setup
    @flags_threshold = Admin_Settings.create!(:key=>"flags_threshold", :value=>30)
    @auto_hding = Admin_Settings.create!(:key=>"auto_hiding", :value=>1)
  end
  # author : Gasser
  test "admin should configure flags threshold" do
    Admin_Settings.configure_flags_threshold 50
    assert_equal Admin_Settings.find_by_key("flags_threshold").value, 50, "Threshold was not changed"
  end

  # author : Gasser
  test "stories should be hidden after setting the threshold" do
    stories = Story.all
    Admin_Settings.configure_flags_threshold 10
    stories.each do |story|
      assert !story.hidden, "Story should be hidden"
    end
  end 

  # author : Gasser
  test "admin should disable auto hiding" do
    Admin_Settings.configure_auto_hiding
    assert_equal Admin_Settings.find_by_key("auto_hiding").value, 0, "Auto Hiding was not changed"
  end
end