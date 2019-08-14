class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_only, only: [:index, :mark_answered, :mark_unanswered]
invisible_captcha only: [:create], honeypot: :subtitle

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
    @unanswered = Question.where(answered: false)
    @answered = Question.where(answered: true)
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_back(fallback_location: root_path) }
        format.html {  }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
    flash[:notice] = "Thanks!  Your question has been sent and we'll get back to you shortly."
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
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

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Your question has been successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def mark_answered
    @question = Question.find(params[:id])
    @question.answered = true
    @question.save
    redirect_back(fallback_location: questions_path)
    flash[:notice] = "That question has been marked answered."
  end

  def mark_unanswered
    @question = Question.find(params[:id])
    @question.answered = false
    @question.save
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

    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
