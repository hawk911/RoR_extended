
App.answers = App.cable.subscriptions.create channel: "AnswersChannel" ,
  connected: ->
    console.log "You are connected to 'AnswersChannel'"
    question_id = $(".question").attr('id')
    @perform 'start_stream_answers',  question_id: question_id

  disconnected: ->


  received: (data) ->
    debugger
    $(".errors").empty();
    console.log("AnswersChannel begin")
    return $('.answers').append JST['templates/answer'](
    answer: data['answer']
    answer_attachments: data['answer_attachments']
    answer_votes: data['answer_votes']
    current_user_id: gon.current_user_id
    question_user_id: data['question_user_id'])
