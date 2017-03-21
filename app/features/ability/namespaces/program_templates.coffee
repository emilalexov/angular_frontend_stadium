define [
  'models/program_template'
], (
  ProgramTemplate
) ->

  (user) ->

    @can 'update', ProgramTemplate, (model) ->
      model.get('user_id') is user.get('id') or
      model.get('author_id') is user.get('id')
