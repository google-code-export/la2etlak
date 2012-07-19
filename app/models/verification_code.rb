class VerificationCode
  attr_accessible :code, :account_id, :verified, :user_id
  
  belongs_to :user, {:foreign_key => "user_id"}
  
  validates :code, presence: true,
  length: { minimum: 4, maximum: 4}
  
  validates :user_id, presence: true,
  uniqueness: true

end
