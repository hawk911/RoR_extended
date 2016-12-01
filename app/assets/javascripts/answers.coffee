question_voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $('.'+ votable.votable_type+'_votes#votable-total-' + votable.votable_id).html( votable.total )
  if votable.user_voted
    $('.'+ votable.votable_type+'_votes#votable-already-links-' + votable.votable_id).removeClass('hidden')
    $('.'+ votable.votable_type+'_votes#votable-not-yet-links-' + votable.votable_id).addClass('hidden')
  else
    $('.'+ votable.votable_type+'_votes#votable-already-links-' + votable.votable_id).addClass('hidden')
    $('.'+ votable.votable_type+'_votes#votable-not-yet-links-' + votable.votable_id).removeClass('hidden')
error_voting = (e,xhr,status,error)  ->
  error_object = $.parseJSON(xhr.responseText)
  $(".errors").empty();
  $('.errors').append(error_object.alert)

$(document).ready ->
  $(document).on('ajax:success', '.answer_votes', question_voting)
  $(document).on('ajax:error', '.answer_votes', error_voting)
