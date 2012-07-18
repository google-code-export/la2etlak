class Admin_Settings < ActiveRecord::Base
  #Author:Diab  ((Mongoid))
  include Mongoid::Document
  include Mongoid::Timestamps

  
   field :key, type: String
   field :value,type: Integer

  attr_accessible :key, :value
end