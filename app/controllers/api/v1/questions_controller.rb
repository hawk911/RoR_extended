class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  def index
    render nothing: true
  end

end
