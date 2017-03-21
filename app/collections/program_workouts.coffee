define [
  'models/program_workout'
], (
  ProgramWorkout
) ->

  class ProgramWorkouts extends Backbone.Collection

    type: 'ProgramWorkouts'

    model: ProgramWorkout

    comparator: ['position', 'id']
