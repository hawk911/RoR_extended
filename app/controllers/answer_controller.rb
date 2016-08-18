class AnswerController < ApplicationController
  before_action :load_question, only: [:index, :show, :create]

  def index
    @answer =@question.answers
  end

  def show
    @answer = @question.answers.find(params[:id])

  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer
    else
      redner :new
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
