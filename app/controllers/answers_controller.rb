class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create, :destroy]
  before_action :load_answer, only: [:destroy]
  before_action :check_owner, only: [:destroy]

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

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def check_owner
    unless current_user.author_of?(@answer)
      render 'common/error', locals: { message: 'Cannot delete the answer' }, status: :forbidden
    end
  end
end
