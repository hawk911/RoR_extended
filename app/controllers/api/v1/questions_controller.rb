class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  before_action :load_questions, only: [:index, :list]

  def index
    respond_with @questions
  end

  def list
    respond_with @questions, each_serializer: QuestionSimpleSerializer
  end

  def show
    respond_with @question, serializer: QuestionComplexSerializer
  end

  private

  def load_questions
    @questions =Question.all
  end
end
