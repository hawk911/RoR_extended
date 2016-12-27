$(document).ready ->
  question_id = $(".question").attr('id')
  App.questions_comments = App.cable.subscriptions.create { channel: "QuestionsCommentsChannel", question: question_id },
    connected: ->
      console.log "You are connected to 'QuestionsCommentsChannel'"
      @perform 'start_stream_questions_comments'

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      console.log("QuestionsCommentsChannel begin")
      $(".errors").empty();
      $('.question_comments').first('.question_comments').append(data)
