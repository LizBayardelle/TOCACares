class AppFormsController < ApplicationController
  before_action :set_app_form, only: [:show, :edit, :update, :destroy]

  # GET /app_forms
  # GET /app_forms.json
  def index
    @app_forms = AppForm.all
  end

  # GET /app_forms/1
  # GET /app_forms/1.json
  def show
  end

  # GET /app_forms/new
  def new
    @app_form = AppForm.new
  end

  # GET /app_forms/1/edit
  def edit
  end

  # POST /app_forms
  # POST /app_forms.json
  def create
    @app_form = AppForm.new(app_form_params)

    respond_to do |format|
      if @app_form.save
        format.html { redirect_to @app_form, notice: 'App form was successfully created.' }
        format.json { render :show, status: :created, location: @app_form }
      else
        format.html { render :new }
        format.json { render json: @app_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_forms/1
  # PATCH/PUT /app_forms/1.json
  def update
    respond_to do |format|
      if @app_form.update(app_form_params)
        format.html { redirect_to @app_form, notice: 'App form was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_form }
      else
        format.html { render :edit }
        format.json { render json: @app_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_forms/1
  # DELETE /app_forms/1.json
  def destroy
    @app_form.destroy
    respond_to do |format|
      format.html { redirect_to app_forms_url, notice: 'App form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_form
      @app_form = AppForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_form_params
      params.require(:app_form).permit(:application_type, :full, :date, :position, :branch, :start_date, :email_non_toca, :mobile, :address, :city, :state, :zip, :for_other, :for_other_email, :recipient_toca_email, :transfer_pending, :bank_name, :bank_phone, :bank_address, :institution_name, :institution_contact, :institution_phone, :institution_address, :requested_amount, :self_fund, :loan_preferred, :loan_preferred_description, :description, :accident, :catastrophe, :counseling, :family_emergency, :health, :memorial, :other_hardship, :other_hardship_description, :intent_signature, :intent_signature_date, :release_signature, :release_signature_date, :approved, :denied, :returned, :closed, :application_status_id, :final_decision_id, :funding_status_id, :user_id)
    end
end
