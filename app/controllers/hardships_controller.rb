class HardshipsController < ApplicationController
  before_action :set_hardship, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /hardships
  # GET /hardships.json
  def index
    @hardships = Hardship.all
  end

  # GET /hardships/1
  # GET /hardships/1.json
  def show
  end

  # GET /hardships/new
  def new
    @hardship = Hardship.new
  end

  # GET /hardships/1/edit
  def edit
  end

  # POST /hardships
  # POST /hardships.json
  def create
    @hardship = Hardship.new(hardship_params)
    @hardship.user_id = current_user.id

    respond_to do |format|
      if @hardship.save
        format.html { redirect_to @hardship, notice: 'Hardship was successfully created.' }
        format.json { render :show, status: :created, location: @hardship }
      else
        format.html { render :new }
        format.json { render json: @hardship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hardships/1
  # PATCH/PUT /hardships/1.json
  def update
    respond_to do |format|
      if @hardship.update(hardship_params)
        format.html { redirect_to @hardship, notice: 'Hardship was successfully updated.' }
        format.json { render :show, status: :ok, location: @hardship }
      else
        format.html { render :edit }
        format.json { render json: @hardship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hardships/1
  # DELETE /hardships/1.json
  def destroy
    @hardship.destroy
    respond_to do |format|
      format.html { redirect_to hardships_url, notice: 'Hardship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardship
      @hardship = Hardship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardship_params
      params.require(:hardship).permit(
        :full_name,
        :date,
        :position,
        :branch,
        :email_non_toca,
        :mobile,
        :address,
        :city,
        :state,
        :zip,
        :bank_name,
        :bank_phone,
        :bank_address,
        :start_date,
        :accident,
        :catastrophe,
        :counseling,
        :family_emergency,
        :health,
        :memorial,
        :other_hardship,
        :other_hardship_description,
        :requested_amount,
        :hardship_description,
        :self_fund,
        :intent_signature,
        :intent_signature_date,
        :release_signature,
        :release_signature_date,
        :status,
        :review_first_status,
        :review_first_reviewer_id,
        :review_second,
        :review_second_reviewer_id,
        :final_decision,
        :user_id
      )
    end
end
