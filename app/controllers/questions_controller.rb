class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]
  before_action :build_answer, only: :show
  before_action :set_gon_current_user, only: :show

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@answer)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    #flash[:notice] = t('flash.success.new_question') if @question.save
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def set_gon_current_user
    gon.current_user_id = current_user ? current_user.id : 0
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :_destroy, :file])
  end

  def check_owner
    unless current_user.author_of?(@question)
      redirect_to @question, notice: t('flash.danger.auth_error')
    end
  end
end
