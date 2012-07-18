class Log < ActiveRecord::Base
  #Author:Diab  ((Mongoid))
  include Mongoid::Document
  include Mongoid::Timestamps

    field :loggingtype, type: Integer
    field :user_id_1,   type: Integer
    field :user_id_2,   type: Integer
    field :admin_id,    type: Integer
    field :interest_id, type: Integer
    field :story_id,    type: Integer
    field :message,     type: String
    

  attr_accessible :admin_id, :interest_id, :loggingtype, :message, :story_id, :user_id_1, :user_id_2
  #used for rendering xls
end