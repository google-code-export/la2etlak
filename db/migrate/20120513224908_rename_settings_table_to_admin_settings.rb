class RenameSettingsTableToAdminSettings < ActiveRecord::Migration
  def up
  	rename_table :settings, :admin_settings
  end

  def down
  	rename_table :admin_settings, :settings
  end
end
