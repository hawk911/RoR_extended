question_id = $(".question").attr('id')
App.answers = App.cable.subscriptions.create { channel: "AnswersChannel", question: question_id },
  connected: ->
    console.log "You are connected to 'AnswersChannel'"
    @perform 'start_stream_answers'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $(".errors").empty();
    console.log("AnswersChannel begin")
    return $(".answers").append(JST["templates/answer"]({
      answer:             data['answer'],
      answer_attachments: data['answer_attachments'],
      answer_rating:      data['answer_rating'],
      current_user_id:    gon.current_user_id,
      question_user_id:   data['question_user_id']
    }));
