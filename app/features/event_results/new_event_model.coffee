define ->

  class NewWorkoutEvent extends Backbone.Model

    urlRoot: '/workout_events'

    defaults:
      personal_workout_id: null
      begins_at: null
      ends_at: null
