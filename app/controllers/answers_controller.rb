class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :set_best]
  before_action :check_owner, only: [:destroy, :update]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    flash[:notice] = t('flash.success.new_answer') if @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: t('flash.success.delete_answer')
  end

  def set_best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.toggle_best!
    else
      flash[:alert] = 'Error'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :body, attachments_attributes: [:id, :_destroy, :file])
  end

  def check_owner
    unless current_user.author_of?(@answer)
      redirect_to @answer.question, notice: t('flash.danger.auth_error')
    end
  end
end
