class SharesController < ApplicationController
  before_filter {user_authenticated?}

end
