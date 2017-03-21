define [
  'models/workout_template'
], (
  WorkoutTemplate
) ->

  (user) ->

    @can 'update', WorkoutTemplate, (model) ->
      model.get('user_id') is user.get('id') or
      model.get('author_id') is user.get('id')
