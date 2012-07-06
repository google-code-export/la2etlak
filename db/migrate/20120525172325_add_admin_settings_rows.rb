class AddAdminSettingsRows < ActiveRecord::Migration
  def up
	Admin_Settings.create!(:key=>"flags_threshold", :value=>10)
	Admin_Settings.create!(:key=>"auto_hiding", :value=>1)
	Admin_Settings.create!(:key=>"statistics_time_span", :value=>30)
  end

  def down
  	Admin_Settings.find_by_key("flags_threshold").destroy 
  	Admin_Settings.find_by_key("auto_hiding").destroy 
  	Admin_Settings.find_by_key("statistics_time_span").destroy 
  end
end
