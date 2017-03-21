define [
  'models/workout_event'
], (
  WorkoutEvent
) ->

  class WorkoutEventCollection extends Backbone.Collection

    model: WorkoutEvent

    url: ->
      "/users/#{@userId}/collections/workout_events"

    initialize: (models, options)->
      @userId = options.user_id
      super
