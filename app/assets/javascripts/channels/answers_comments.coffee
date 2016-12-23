App.answers_comments = App.cable.subscriptions.create  channel: "AnswersCommentsChannel",
  connected: ->
    console.log "You are connected to 'AnswersCommentsChannel'"
    @perform 'start_stream_answers_comments'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log("AnswersCommentsChannel begin")
    $(".errors").empty();
    debugger;
    $('.answer_comments').first('.answer_comments').append(data)
