class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :set_best]
  #before_action :check_owner, only: [:destroy, :update]

  respond_to :js

  def create
    #flash[:notice] = t('flash.success.new_answer') if @answer.save
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    #redirect_to @answer.question, notice: t('flash.success.delete_answer')
    respond_with(@answer.destroy, :location => @answer.question)
  end

  def set_best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.toggle_best!
    else
      flash[:alert] = t('flash.danger.error')
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
