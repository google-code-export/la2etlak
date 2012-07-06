class Admin_Settings < ActiveRecord::Base
  attr_accessible :key, :value
=begin
  Method Descritpion: A static method that takes as an input the threshold 
  of the flags if first loads the flags_thershold value from the admin_settings
  table then it checks if the the auto_hiding is enabled or not then it updates
  the threhsold in the database and check all the stories if it exceeded the 
  threshold or not to hide it or not.
  Parameters: (flags_number)
  Author: Gasser
=end
  def self.configure_flags_threshold (flags_number)
    if Admin_Settings.find_by_key("auto_hiding").value == 1
      @threshold = Admin_Settings.find_by_key("flags_threshold")
      @threshold.value = flags_number
      @threshold.save
      stories=Story.all
        stories.each do |story|
          if story.flags.count >= flags_number
             story.hidden = true
          elsif story.flags.count < flags_number
             story.hidden = false
          end
            story.save
        end
    end
    Log.create!(loggingtype: 1,user_id_1: nil,user_id_2: nil,admin_id: nil,story_id: nil,message: "Admin changed the flags threshold")
  end
=begin
  Method Description
=end
  def self.configure_auto_hiding
    @auto_hiding = Admin_Settings.find_by_key("auto_hiding")
    if @auto_hiding.value == 0
      @auto_hiding.value = 1
    else 
      @auto_hiding.value = 0
    end
    @auto_hiding.save
    Log.create!(loggingtype: 1,user_id_1: nil,user_id_2: nil,admin_id: nil,story_id: nil,message: "Admin changed the auto hiding feature")
  end
=begin 
  Method Description: A static method that is called in the flag_story method 
  in users_controller to check after flagging any story if the number of flags
  exceeds the threshold or not to hide this story or not.All of that after 
  checking the global variable auto_hiding which the admin changes from the checkbox.
=end
  def self.update_story_if_flagged (story)
  	if Admin_Settings.find_by_key("auto_hiding").value == 1
      if(story.flags.count >= Admin_Settings.find_by_key("flags_threshold").value)
  		  story.hidden = true
  	  else
  		  story.hidden = false
  	  end
      story.save
    end
end

=begin
This method takes the number of days as an input, checks if its not equal to zero and sets the value of the time span
to this number which is to be checked lately whenever statistics are shown.
Inputs: no of days to be set
Outputs: non
NB: "statistics_time_span" key is to be put initially = 30. But now for the sake of testing, please type this command
in your terminal:
$ Admin_Settings.create!(key:"statistics_time_span", value:30)
Author: Bassem
=end
  def self.set_statistics_span (days)
    days_value = days.to_i
    span= Admin_Settings.find_by_key("statistics_time_span")
    
    if (days_value <= 0)
     return 0
    else
      span.value = days_value
      span.save
      return 1
    end
  end
end
