class AnswersCommentsChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
  end

  def start_stream_answers_comments
    stream_from "/question/#{params[:question]}/answers/comments"
  end

end
