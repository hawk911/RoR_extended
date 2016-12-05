question_voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $('#'+ votable.votable_type+'-votable-total-' + votable.votable_id).html( votable.total )
  if votable.user_voted
    $('#'+ votable.votable_type+'-votable-already-links-' + votable.votable_id).removeClass('hidden')
    $('#'+ votable.votable_type+'-votable-not-yet-links-' + votable.votable_id).addClass('hidden')
  else
    $('#'+ votable.votable_type+'-votable-already-links-' + votable.votable_id).addClass('hidden')
    $('#'+ votable.votable_type+'-votable-not-yet-links-' + votable.votable_id).removeClass('hidden')
error_voting = (e,xhr,status,error)  ->
  error_object = $.parseJSON(xhr.responseText)
  $(".errors").empty();
  $('.errors').append(error_object.alert)

$(document).ready ->
  $(document).on('ajax:success', '.question_votes', question_voting)
  $(document).on('ajax:error', '.question_votes', error_voting)
