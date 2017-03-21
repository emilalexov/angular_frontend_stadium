define [
  'models/personal_workout'
], (
  PersonalWorkout
) ->

  (user) ->

    @can 'update', PersonalWorkout, (model) ->
      personId = model.get('person_id')
      isPro = user.get('is_pro')
      isPro and _.contains(user.clients.pluck('id'), personId)