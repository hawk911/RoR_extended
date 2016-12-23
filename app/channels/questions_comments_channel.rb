class QuestionsCommentsChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    #Rails.logger.info "You are disconnected"
  end

  def start_stream_questions_comments
    stream_from "/question/#{params[:question]}/comments"
  end

end
