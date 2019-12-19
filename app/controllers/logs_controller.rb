class LogsController < ApplicationController
  before_action :set_log, only: [:show, :destroy]
  before_action :only_approved_users, only: [:index]
  before_action :admin_only, only: [:index]

  def index
    @logs = Log.order(created_at: :desc).page(params[:page]).per(25)
  end


  def new
    @log = Log.new
  end


  def create
    @log = Log.new(log_params)

    respond_to do |format|
      if @log.save
        format.html { redirect_to @log }
        format.json { render :show, status: :created, location: @log }
      else
        format.html { render :new }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url, notice: 'Log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  def only_approved_users
    unless current_user && current_user.authorized_by_admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you have to wait for your account to be authorized by an administrator to do that.  If it's been more than 24 hours since you registered, feel free to email an admin to check on the status of your application."
    end
  end



  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an admin to do that."
    end
  end



  private

  def set_log
    @log = Log.find(params[:id])
  end


  def log_params
    params.require(:log).permit(
      :category,
      :action,
      :automatic,
      :object,
      :object_linkable,
      :object_category,
      :object_id,
      :taken_by_user,
      :user_id
    )
  end

end
