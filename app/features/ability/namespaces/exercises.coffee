define [
  'models/exercise'
], (
  Exercise
) ->

  (user) ->

    @can 'view', Exercise, (model) ->
      model.get('is_public') or
      model.get('user_id') is user.get('id') or
      model.get('author_id') is user.get('id')

    @can 'add_to_library', Exercise, (model) ->
      model.get('is_public') and
      model.get('user_id') isnt user.get('id') and
      model.get('author_id') isnt user.get('id')

    @can 'update', Exercise, (model) ->
      model.get('author_id') is user.get('id')
