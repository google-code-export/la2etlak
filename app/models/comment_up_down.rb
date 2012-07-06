class CommentUpDown < ActiveRecord::Base

=begin
    
  This class is solely done by me, Menisy.


=end

  attr_accessible :action
  belongs_to :user
  belongs_to :comment
  
=begin
  Adds the action that has just happened to the log, the type
  of un-up/up is determened by the comment model that calls
  this method passing the parameter before as specified.
  Inputs: commnter (user who is the comment owner).
          before (int which tells if the action is up or un-up)
  Output: none
  Author: Menisy
=end
  def add_to_log(commenter,before=1)
    msg = nil
    if self.action == 1 then
      if before == 1
        msg = "upped"
      else
        msg = "un-upped"
      end
    else
      if before == 1
        msg = "downed"
      else
        msg = "un-downed"
      end
    end
    user_name = self.user.name  ||  self.user.email.split('@')[0]
    commenter_name = commenter.name  ||  commenter.email.split('@')[0]
    Log.create!(loggingtype: 2,user_id_1: self.user.id,user_id_2: commenter.id,admin_id: nil,story_id: nil,interest_id: nil,message: user_name + " " + msg + " the comment \"" +  self.comment.content +  "\"" + " by " + commenter_name )
    Admin.push_notifications "/admins/index" ,""
  end
end
