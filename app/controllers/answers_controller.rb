class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :set_best]
  before_action :check_owner, only: [:destroy, :update]
  after_action :publish_answer, only: [:create]

  include Voted

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

  def publish_answer
    return if @answer.errors.any?

    attachments = []
    @answer.attachments.each do |a|
      attach = {}
      attach[:id] = a.id
      attach[:file_url] = a.file.url
      attach[:file_name] = a.file.identifier
      attachments << attach
    end

    ActionCable.server.broadcast(
      "answers_question_#{@question.id}",
      answer:             @answer,
      answer_attachments: attachments,
      answer_votes:      @answer.votes,
      question_user_id:   @answer.question.user_id
    )
  end
end
