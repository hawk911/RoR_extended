class AnswersCommentsChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
  end

  def start_stream_answers_comments(data)
    #stream_from "answers_#{data['question_id']/comments}"
    stream_from "/question/#{params[:question]}/answers/comments"
  end

end
