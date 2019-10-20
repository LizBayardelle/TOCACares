class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :update, :destroy]
  before_action :admin_only, only: [:destroy]


  def index
    @responses = Response.all
  end


  def show
  end


  def new
    @response = Response.new
  end


  def create
    @response = Response.new(response_params)
    @message = Message.find(@response.message_id)

    respond_to do |format|
      if @response.save
        if MessagingMailer.new_response_email(@response).deliver
          Log.create(category: "Email", action: "New Message Response Notification Email Sent", automatic: true, object: true, object_linkable: true, object_category: "message", object_id: @message.id, taken_by_user: false)
        end
        format.html { redirect_to message_path(@response.message_id), notice: 'Your response has been sent and the appropriate parties have been notified via email.' }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to responses_url, notice: 'Response was successfully destroyed.' }
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

    def set_response
      @response = Response.find(params[:id])
    end


    def response_params
      params.require(:response).permit(
        :user_id,
        :message_id,
        :body
      )
    end
end
