App.answers = App.cable.subscriptions.create channel: "AnswersChannel" ,
  connected: ->
    question_id = $(".question").attr('id')
    console.log "You are connected to 'AnswersChannel' - id:  #{question_id}"
    @perform 'start_stream_answers',  question_id: question_id

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    debugger
    console.log("AnswersChannel begin")
    console.log(data['answer'])

