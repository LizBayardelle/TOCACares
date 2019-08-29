class TestimonialsController < ApplicationController
  before_action :set_testimonial, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_only, only: [:approve_testimonial]


  # GET /testimonials
  # GET /testimonials.json
  def index
    @testimonials = Testimonial.all
    @featured_hardship = Testimonial.where(category: "Hardship", approved: true, featured: true).limit(1)
    @featured_scholarship = Testimonial.where(category: "Scholarship", approved: true, featured: true).limit(1)
    @featured_charity = Testimonial.where(category: "Charity", approved: true, featured: true).limit(1)
    @other_hardships = Testimonial.where(category: "Hardship", approved: true, featured: true).all[1..-1]
    @other_scholarships = Testimonial.where(category: "Scholarship", approved: true, featured: true).all[1..-1]
    @other_charities = Testimonial.where(category: "Charity", approved: true, featured: true).all[1..-1]
  end

  # GET /testimonials/1
  # GET /testimonials/1.json
  def show
  end

  # GET /testimonials/new
  def new
    @testimonial = Testimonial.new
  end

  # GET /testimonials/1/edit
  def edit
  end

  # POST /testimonials
  # POST /testimonials.json
  def create
    @testimonial = Testimonial.new(testimonial_params)
    @testimonial.user_id = current_user.id

    respond_to do |format|
      if @testimonial.save
        Log.create(category: "User Action", action: "New Testimonial Submitted", automatic: false, object: true, object_linkable: true, object_category: "testimonial", object_id: @testimonial.id, taken_by_user: true, user_id: @testimonial.user_id)
        if TestimonialMailer.send_testimonial_email(@testimonial).deliver
          Log.create(category: "Automatic", action: "New Testimonial Email Sent to Admins", automatic: true, object: true, object_linkable: true, object_category: "testimonial", object_id: @testimonial.id, taken_by_user: true, user_id: @testimonial.user_id)
        end
        format.html { redirect_to root_path, notice: "Thank you for submitting a testimonial!  As soon as it's approved by administrators it could be featured on the TOCA Cares site." }
        format.json { render :show, status: :created, location: @testimonial }
      else
        format.html { render :new }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /testimonials/1
  # PATCH/PUT /testimonials/1.json
  def update
    respond_to do |format|
      if @testimonial.update(testimonial_params)
        format.html { redirect_to @testimonial, notice: 'Testimonial was successfully updated.' }
        format.json { render :show, status: :ok, location: @testimonial }
      else
        format.html { render :edit }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testimonials/1
  # DELETE /testimonials/1.json
  def destroy
    @testimonial.destroy
    respond_to do |format|
      format.html { redirect_to home_testimonials_path, notice: 'That testimonial has been deleted.' }
      format.json { head :no_content }
    end
  end

  def approve_testimonial
    @testimonial = Testimonial.find(params[:id])
    if @testimonial.update_attributes(approved: true)
      Log.create(category: "Admin Action", action: "Preauthorization Created", automatic: false, object: true, object_linkable: true, object_category: "testimonial", object_id: @testimonial.id, taken_by_user: true, user_id: current_user.id)
      redirect_back(fallback_location: home_testimonials_path)
      flash[:notice] = "That testimonial has been approved.  You may now choose to feature it on the testimonials page."
    else
      redirect_back(fallback_location: home_testimonials_path)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end

  def feature_testimonial
    @testimonial = Testimonial.find(params[:id])
    if @testimonial.update_attributes(featured: true)
      Log.create(category: "Admin Action", action: "Testimonial Featured", automatic: false, object: true, object_linkable: true, object_category: "testimonial", object_id: @testimonial.id, taken_by_user: true, user_id: current_user.id)
      redirect_back(fallback_location: home_testimonials_path)
      flash[:notice] = "That testimonial has been featured."
    else
      redirect_back(fallback_location: home_testimonials_path)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end

  def unfeature_testimonial
    @testimonial = Testimonial.find(params[:id])
    if @testimonial.update_attributes(featured: false)
      Log.create(category: "Admin Action", action: "Testimonial Feature Removed", automatic: false, object: true, object_linkable: true, object_category: "testimonial", object_id: @testimonial.id, taken_by_user: true, user_id: current_user.id)
      redirect_back(fallback_location: home_testimonials_path)
      flash[:notice] = "That testimonial has been unfeatured."
    else
      redirect_back(fallback_location: home_testimonials_path)
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
    # Use callbacks to share common setup or constraints between actions.
    def set_testimonial
      @testimonial = Testimonial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testimonial_params
      params.require(:testimonial).permit(
        :category,
        :title,
        :body,
        :featured,
        :approved,
        :user_id
      )
    end
end
