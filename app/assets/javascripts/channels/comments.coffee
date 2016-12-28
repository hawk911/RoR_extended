subscribeToComments = ->
  return if App.comments
  App.comments = App.cable.subscriptions.create 'CommentsChannel',
    received: (comment) ->
      return if gon.user_id is comment.user_id
      console.log "You are connected to 'CommentsChannel'"
      commentableClass = comment.commentable_type.toLowerCase()
      addCommentEl = $("#add-comment-to-#{commentableClass}-#{comment.commentable_id}")
      addCommentEl.append(JST['templates/comment'](comment))

ready = ->
  subscribeToComments()

$(document).on('turbolinks:load', ready)
