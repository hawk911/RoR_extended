function ready() {
 $('.edit-question-link').click(function(e) {
   e.preventDefault()
   $(this).hide()
   question_id = $(this).data('questionId')
   $('form#edit-question-' + question_id).show()
 });

  $('.edit-answer-link').click(function(e) {
   e.preventDefault()
   $(this).hide()
   answer_id = $(this).data('answerId')
   $('form#edit-answer-' + answer_id).show()
 });

 $('.select-best-answer').click(function(e) {
    e.preventDefault();
    var answerId = $(this).data('answerId');
    var answerSelector = 'div[data-answer-id=' + answerId + ']'
    $(this).hide();
    var answerUrl = "/answers/" + answerId + "/set_best";
    $.post( answerUrl, {}, function( data ) {
      if (data.success) {
        $( '<span class="glyphicon glyphicon-ok best-answer" aria-hidden="true"></span>' ).prependTo(answerSelector);
      } else {
          alert ('Ошибка!')
      }
    });

 });

};

//$(document).on('ajax:success', ready);
//$(document).on('update-object', ready);
$(document).on('turbolinks:load', ready);
$(document).ready(ready)
$(document).on('page:update', ready)
