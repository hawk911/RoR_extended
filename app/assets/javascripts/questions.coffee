voting = (e, data, status, xhr) ->
  debugger
  votable = $.parseJSON(xhr.responseText)
  $('#votable-total-' + votable.votable_id).html( votable.total )
  if votable.user_voted
    $('#votable-already-links-' + votable.votable_id).removeClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).addClass('hidden')
  else
    $('#votable-already-links-' + votable.votable_id).addClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).removeClass('hidden')
error_voting = (e,xhr,status,error)  ->
  debugger
  error_object = $.parseJSON(xhr.responseText)
  $(".errors").empty();
  $('.errors').append(error_object.alert)

$(document).ready ->
  $(document).on('ajax:success', '.voting', voting)
  $(document).on('ajax:error', '.voting', error_voting)
