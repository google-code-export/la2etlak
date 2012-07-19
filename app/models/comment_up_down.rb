class CommentUpDown
  
include Mongoid::Document
include Mongoid::Timestamps
=begin
  This class is solely done by me, Menisy.
=end

field :action, type: Integer
field :comment_id, type: Integer
field :comment_id, type: Integer
#field :created_at, type: datetime 
#field :created_at, type: datetime 
#Since I added the timestamps we dont need them 

add_index "comment_up_downs", ["user_id", "comment_id"], :name => "index_comment_up_downs_on_user_id_and_comment_id"

attr_accessible :action
  
belongs_to :user
belongs_to :comment
end