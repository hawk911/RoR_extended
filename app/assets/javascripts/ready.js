var ready  = function() {
 $('body').on('click', '.edit-question-link', function(e) {
   e.preventDefault()
   $(this).hide()
   question_id = $(this).data('questionId')
   $('form#edit-question-' + question_id).show()
 });

$('body').on('click', '.edit-answer-link', function(e) {
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

 $('.remove_file_field').click(function(e) {
    e.preventDefault();
    $(this).parent().remove();
  });

};

$(document).ready(ready);
$(document).on('turbolinks:load', ready);
$(document).on('page:update', ready);

