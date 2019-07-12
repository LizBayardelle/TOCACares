class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @hardships = Hardship.where(user_id: @user.id)
  end

  def index
    @users = User.all
  end

end
