var ready  = function() {
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
    $(answerSelector).replaceWith("<%= j render @answer %>");
 });

};
//$(document).on('ajax:success', ready);
//$(document).on('update-object', ready);
$(document).ready(ready);
$(document).on('turbolinks:load', ready);
$(document).on('page:update', ready);

