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
        u.authorized_by_admin = true
        u.save
        redirect_to users_path, notice: "That user already had an account, but their permissions have been updated." and return
      end
    end

    previous.each do |p|
      if @authorization.email == p.email
        p.admin = @authorization.admin
        p.committee = @authorization.committee
        p.save
        if PreauthorizationMailer.send_preauthorization_email(p).deliver
          if @authorization.admin && @authorization.committee
            Log.create(category: "Email", action: "Admin and Committee Preauthorization Email Resent (" + @authorization.email + ")", automatic: true, object: false, taken_by_user: false)
          elsif @authorization.admin
            Log.create(category: "Email", action: "Admin Preauthorization Email Resent (" + @authorization.email + ")", automatic: true, object: false, taken_by_user: false)
          else
            Log.create(category: "Email", action: "Committee Preauthorization Email Resent (" + @authorization.email + ")", automatic: true, object: false, taken_by_user: false)
          end
        end
        redirect_to users_path, notice: "That user was already preauthorized, but the info has been updated and an invitation email has been resent." and return
      end
    end

    respond_to do |format|
      if @authorization.save
        PreauthorizationMailer.send_preauthorization_email(@authorization).deliver
        if @authorization.admin && @authorization.committee
          Log.create(category: "Admin Action", action: "Admin and Committee Preauthorization Created (" + @authorization.email + ")", automatic: false, object: false, taken_by_user: true, user_id: current_user.id)
        elsif @authorization.admin
          Log.create(category: "Admin Action", action: "Admin Preauthorization Created (" + @authorization.email + ")", automatic: false, object: false, taken_by_user: true, user_id: current_user.id)
        else
          Log.create(category: "Admin Action", action: "Committee Preauthorization Created (" + @authorization.email + ")", automatic: false, object: false, taken_by_user: true, user_id: current_user.id)
        end
        format.html { redirect_to users_path, notice: 'That email has been preauthorized and an email invite has been sent.' }
        format.json { render :show, status: :created, location: @authorization }
      else
        format.html { render :new }
        format.json { render json: @authorization.errors, status: :unprocessable_entity }
      end
    end
  end


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
