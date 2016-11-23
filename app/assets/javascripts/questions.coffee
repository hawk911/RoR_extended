voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $('#votable-total-' + votable.votable_id).html( votable.total )

  if votable.user_voted
    $('#votable-already-links-' + votable.votable_id).removeClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).addClass('hidden')
  else
    $('#votable-already-links-' + votable.votable_id).addClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).removeClass('hidden')

$(document).ready ->
  $(document).on('ajax:success', '.voting', voting)
