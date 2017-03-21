define [
  '../scheduled_workout_slider/collection'
], (
  WorkoutEventCollection
) ->

  class DayModel extends Backbone.Model

    type: 'DayModel'

    constructor: (attrs) ->
      @workout_events = new WorkoutEventCollection([], user_id: 0)
      super
