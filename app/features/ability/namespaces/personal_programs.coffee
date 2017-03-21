define [
  'models/personal_program'
], (
  PersonalProgram
) ->

  (user) ->

    @can 'update', PersonalProgram, (model) ->
      personId = model.get('person_id')
      isPro = user.get('is_pro')
      isPro and _.contains(user.clients.pluck('id'), personId)