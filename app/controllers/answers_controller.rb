class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = t('flash.success.new_answer')
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question, notice: 'Your answer successfully deleted'
end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
