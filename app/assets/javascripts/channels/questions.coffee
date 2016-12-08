App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    console.log "You are connected to 'QuestionsChannel'"
    @perform 'start_stream'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $(".errors").empty();
    console.log(data)
    $('.questions').last('.questions').append(data)
