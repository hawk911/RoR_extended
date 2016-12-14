App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    console.log "You are connected to 'QuestionsChannel'"
    @perform 'start_stream_questions'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log("QuestionChannel begin")
    $(".errors").empty();
    $('.questions').last('.questions').append(data)
