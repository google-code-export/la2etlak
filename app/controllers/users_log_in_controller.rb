class UsersLogInController < ApplicationController

  def create
  #end
    @uLog = UserLogIn.new(:user_id=>params[:user_id])
    if @uLog.save
      format.json { render json: @uLog, status: :created }
    else
      format.json { render json: @uLog.errors, status: :unprocessable_entity }
    end
  end
end
