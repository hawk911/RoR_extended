App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    console.log "You are connected to 'QuestionsChannel'"
    @perform 'start_stream'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('.notice').remove()
    console.log(data)
    $('.questions').last('.questions').append(data)
    $('.question').before("<h3 class='notice'>Please wait for a while, someone will answer you soon.</h3>")
    $('#question_title').val('')
    $('#question_body').val('')
