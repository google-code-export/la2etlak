class SharesController < ApplicationController
  before_filter {user_authenticated?}
  before_filter {user_verified?}

end
