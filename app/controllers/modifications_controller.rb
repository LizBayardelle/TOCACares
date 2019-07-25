class ModificationsController < ApplicationController
  before_action :set_modification, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :committee_only, only: [:new, :create, :update, :destroy]


  # GET /modifications
  # GET /modifications.json
  def index
    @modifications = Modification.all
  end

  # GET /modifications/1
  # GET /modifications/1.json
  def show

  end

  # GET /modifications/new
  def new
    @modification = Modification.new
  end

  # GET /modifications/1/edit
  def edit
  end

  # POST /modifications
  # POST /modifications.json
  def create
    @modification = Modification.new(modification_params)
    @modification.user_id = current_user.id

    respond_to do |format|
      if @modification.save
        format.html { redirect_back(fallback_location: home_pending_path) }
        format.html { flash[:notice] = 'Your modification has been suggested and will be sent to the applicant once seconded by another committee member.' }
      else
        format.html { render :new }
        format.json { render json: @modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modifications/1
  # PATCH/PUT /modifications/1.json
  def update
    respond_to do |format|
      if @modification.update(modification_params)
        format.json { render :show, status: :ok, location: @modification }
      else
        format.html { render :edit }
        format.json { render json: @modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modifications/1
  # DELETE /modifications/1.json
  def destroy
    @modification.destroy
    respond_to do |format|
      format.html { redirect_to modifications_url, notice: 'Your modification has been successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def committee_only
    unless current_user && current_user.committee
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be a committee member to modify an application."
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_modification
      @modification = Modification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modification_params
      params.require(:modification).permit(
        :body,
        :seconded,
        :user_id,
        :commentable_id
      )
    end
end
