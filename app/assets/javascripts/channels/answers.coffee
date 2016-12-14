App.answers = App.cable.subscriptions.create channel: "AnswersChannel" ,
  connected: ->
    console.log "You are connected to 'AnswersChannel'"
    question_id = $(".question").attr('id')
    @perform 'start_stream_answers',  question_id: question_id

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    debugger
    console.log("AnswersChannel begin")
    console.log(data['answer'])

