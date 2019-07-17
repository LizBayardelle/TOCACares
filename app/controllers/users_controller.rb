class UsersController < ApplicationController
  before_action :only_self, only: [:show]
  before_action :admin_only, only: [:index]

  def show
    @user = User.find(params[:id])
    @hardships = Hardship.where(user_id: @user.id)
  end

  def index
    @users = User.all
  end

  def only_self
    @user = User.find(params[:id])
    unless current_user && @user.id == current_user.id
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you can only access your own user page."
    end
  end

  def admin_only
    redirect_back(fallback_location: root_path)
    flash[:warning] = "Sorry, you must be an administrator to access that page."
  end

end
