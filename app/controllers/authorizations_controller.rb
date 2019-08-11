class AuthorizationsController < ApplicationController
  before_action :set_authorization, only: [:show, :destroy]
  before_action :admin_only


  # GET /authorizations
  # GET /authorizations.json
  def index
    @authorizations = Authorization.all
  end

  # GET /authorizations/new
  def new
    @authorization = Authorization.new
  end

  # POST /authorizations
  # POST /authorizations.json
  def create
    @authorization = Authorization.new(authorization_params)
    users = User.all
    previous = Authorization.all

    users.each do |u|
      if @authorization.email == u.email
        u.admin = @authorization.admin
        u.committee = @authorization.committee
        u.save
        redirect_to users_path, notice: "That user already had an account, but their permissions have been updated." and return
      end
    end

    previous.each do |p|
      if @authorization.email == p.email
        p.admin = @authorization.admin
        p.committee = @authorization.committee
        p.save
        # resend email
        redirect_to users_path, notice: "That user was already preauthorized, but the info has been updated and an invitation email has been resent." and return
      end
    end

    respond_to do |format|
      if @authorization.save
        format.html { redirect_to users_path, notice: 'That email has been preauthorized and an email invite has been sent.' }
        format.json { render :show, status: :created, location: @authorization }
      else
        format.html { render :new }
        format.json { render json: @authorization.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /authorizations/1
  # DELETE /authorizations/1.json
  def destroy
    @authorization.destroy
    respond_to do |format|
      format.html { redirect_to authorizations_url, notice: 'Authorization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an admin to do that."
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authorization
      @authorization = Authorization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authorization_params
      params.require(:authorization).permit(
        :email,
        :admin,
        :committee,
        :account_created
      )
    end
end
