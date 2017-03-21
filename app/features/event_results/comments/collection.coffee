define [
  'models/comment'
], (
  Comment
) ->

  class Comments extends Backbone.Collection

    commentable_id: undefined

    commentable_type: 'WorkoutEvent'

    model: Comment

    initialize: ->
      @__defineGetter__('commentable_id', -> @workout_event.id)
