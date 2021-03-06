App.answers = App.cable.subscriptions.create channel: "AnswersChannel" ,
  connected: ->
    question_id = $(".question").attr('id')
    console.log "You are connected to 'AnswersChannel' - id:  #{question_id}"
    @perform 'start_stream_answers',  question_id: question_id

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
      return if gon.user_id is data.answer.user_id
      $(".errors").empty();
      console.log("AnswersChannel begin")
      $('.answers').append JST['templates/answer'](answer: data['answer'],
      answer_attachments: data['answer_attachments'],
      answer_votes: data['answer_votes'],
      current_user_id: gon.current_user_id)

