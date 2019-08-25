class ValuesController < ApplicationController
  before_action :set_value, only: [:edit, :update, :destroy]
  before_action :admin_only



  def index
    @values = Value.order(created_at: :desc)
  end



  def new
    @value = Value.new
  end



  def edit
  end



  def create
    @value = Value.new(value_params)

    respond_to do |format|
      if @value.save
        format.html {
          Log.create(category: "Admin Action", action: "New Fund Information Data Entered", automatic: false, object: true, object_linkable: true, object_category: "value", object_id: @value.id, taken_by_user: true, user_id: current_user.id)
          redirect_to values_path, notice: 'That data was successfully created.'
        }
        format.json { render :show, status: :created, location: @value }
      else
        format.html { render :new }
        format.json { render json: @value.errors, status: :unprocessable_entity }
      end
    end
  end



  def update
    respond_to do |format|
      if @value.update(value_params)
        format.html {
          Log.create(category: "Admin Action", action: "Fund Information Data Updated", automatic: false, object: true, object_linkable: true, object_category: "value", object_id: @value.id, taken_by_user: true, user_id: current_user.id)
          redirect_to values_path, notice: 'That data was successfully updated.'
        }
        format.json { render :show, status: :ok, location: @value }
      else
        format.html { render :edit }
        format.json { render json: @value.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    @value.destroy
    respond_to do |format|
      format.html {
        Log.create(category: "Admin Action", action: "Fund Information Data Deleted", automatic: false, object: true, object_linkable: true, object_category: "value", object_id: @value.id, taken_by_user: true, user_id: current_user.id)
        redirect_to values_url, notice: 'That data successfully destroyed.'
      }
      format.json { head :no_content }
    end
  end




  def select_value
    @value = Value.find(params[:id])
    Value.update_all(selected: false)
    if @value.update_attributes(selected: true)
      Log.create(category: "Admin Action", action: "New Fund Information Data Selected", automatic: false, object: true, object_linkable: true, object_category: "value", object_id: @value.id, taken_by_user: true, user_id: current_user.id)
      redirect_back(fallback_location: values_path)
      flash[:notice] = "That data set has been selected."
    else
      redirect_back(fallback_location: values_path)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an admin to do that."
    end
  end



  private

  def set_value
    @value = Value.find(params[:id])
  end


  def value_params
    params.require(:value).permit(:current_year, :matching_ratio, :individual_contributions, :shareholder_matching, :total_fund_value)
  end

end
