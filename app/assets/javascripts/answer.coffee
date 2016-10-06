->
 $('.edit-answer-link').click (e) ->
   debbuger()
   e.preventDefault()
   $(this).hide()
   answer_id = $(this).data('answerId')
   $('edit-answer-'+answer_id).show()





