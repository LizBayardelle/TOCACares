class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_only, only: [:index, :mark_answered, :mark_unanswered]
  invisible_captcha only: [:create], honeypot: :subtitle



  def index
    @questions = Question.all
    @unanswered = Question.where(answered: false)
    @answered = Question.where(answered: true)
  end



  def show
  end



  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        Log.create!(category: "User Action", action: "New Question Submitted", automatic: false, object: true, object_linkable: true, object_category: "question", object_id: @question.id, taken_by_user: false)
        if NewQuestionMailer.new_question_email(@question).deliver
          Log.create!(category: "Email", action: "New Question Email Sent to Admins", automatic: true, object: true, object_linkable: true, object_category: "question", object_id: @question.id, taken_by_user: false)
        end
        format.html { redirect_back(fallback_location: root_path) }
        format.html {  }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
    flash[:notice] = "Thanks!  Your question has been sent and we'll get back to you shortly."
  end



  def update
    respond_to do |format|
      if @question.update(question_params)
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Your question has been successfully deleted.' }
      format.json { head :no_content }
    end
  end



  def mark_answered
    @question = Question.find(params[:id])
    @admin = current_user
    @question.answered = true
    @question.save
    Log.create(category: "Admin Action", action: "Question Marked Answered by Admin", automatic: false, object: true, object_linkable: true, object_category: "question", object_id: @question.id, taken_by_user: true, user_id: @admin.id)
    redirect_back(fallback_location: questions_path)
    flash[:notice] = "That question has been marked answered."
  end



  def mark_unanswered
    @question = Question.find(params[:id])
    @admin = current_user
    @question.answered = false
    @question.save
    Log.create(category: "Admin Action", action: "Question Marked Unanswered by Admin", automatic: false, object: true, object_linkable: true, object_category: "question", object_id: @question.id, taken_by_user: true, user_id: @admin.id)
    redirect_back(fallback_location: questions_path)
    flash[:notice] = "That question has been marked unanswered."
  end



  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an admin to do that."
    end
  end



  private


  def set_question
    @question = Question.find(params[:id])
  end



  def question_params
    params.require(:question).permit(
      :name,
      :email,
      :subject,
      :body,
      :answered
    )
  end
end
