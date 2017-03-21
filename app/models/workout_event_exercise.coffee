define [
  './workout_exercise'
  'collections/exercise_properties'
  'collections/exercise_results'
], (
  WorkoutsExercise
  ExerciseProperties
  ExerciseResults
) ->

  class WorkoutsEventExercise extends WorkoutsExercise

    type: 'WorkoutsEventExercise'

    constructor: ->
      @_nestedModelsInit
        properties: ExerciseProperties
        exercise_results: ExerciseResults
      super
