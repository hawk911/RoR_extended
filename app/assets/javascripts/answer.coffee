# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

->
 $('.edit-answer-link').click (e) ->
   e.preventDefault();
   $(this).hide();
   answer_id = $(this).data('answerId')
   console.log(answer_id)
   $('form#edit-answer-'+answer_id).show();
   console.log('form#edit-answer-'+answer_id)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)
