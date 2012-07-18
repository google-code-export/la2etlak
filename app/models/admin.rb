class Admin
        #this is added for authlogic gem
    acts_as_authentic


	include Mongoid::Document
	field :first_name, type: String
	field :last_name, type: String
	field :email, type: String
	field :password, type: String
	field :password_confirmation, type: String
	belongs_to :interest_id

  #attr_accessible :first_name, :last_name,:email, :password, :password_confirmation
end