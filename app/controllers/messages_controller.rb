class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :destroy, :close_issue]
  before_action :admin_only, only: [:close_issue]

  def index
    @messages = Message.where(issue_closed: false)
    @closed_messages = Message.where(issue_closed: true)
  end


  def show
    @new_response = Response.new
  end


  def new
    @message = Message.new
  end


  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        if MessagingMailer.new_message_email(@message).deliver
          Log.create(category: "Email", action: "New Message Notification Email Sent", automatic: true, object: true, object_linkable: true, object_category: "message", object_id: @message.id, taken_by_user: false)
        end
        format.html { redirect_to @message, notice: 'Your message has been sent!' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an admin to do that."
    end
  end

  def close_issue
    @message = Message.find(params[:id])
    @message.issue_closed = true
    if @message.save
      Log.create(category: "Admin Action", action: "Message Thread Issue Closed", automatic: false, object: true, object_linkable: true, object_category: "message", object_id: @message.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: messages_path)
    flash[:notice] = "That message thread has been marked closed."
  end


  private

    def set_message
      @message = Message.find(params[:id])
    end


    def message_params
      params.require(:message).permit(
        :from_user_id,
        :user_id,
        :subject,
        :message,
        :read,
        :ref_application_type,
        :ref_application_id,
        :issue_closed
      )
    end
end
