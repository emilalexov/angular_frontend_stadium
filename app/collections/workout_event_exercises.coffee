define [
  './workout_exercises'
  'models/workout_event_exercise'
], (
  WorkoutExercises
  WorkoutEventExercise
) ->

  class WorkoutEventExercises extends WorkoutExercises

    type: 'WorkoutEventExercises'

    model: WorkoutEventExercise
