define [
  './concerns/nested_models'
  'models/user_profile'
], (
  NestedModelsConcern
  User
) ->

  class Exercise extends Backbone.Model

    type: 'Exercise'

    urlRoot: '/exercises/'

    validation:
      name:
        required: true

    constructor: ->
      @_nestedModelsInit
        author: User
      super

    initialize: (_options) ->
      @__defineGetter__ 'parent', @_getFolder
      @__defineGetter__ 'folder', @_getFolder

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection?.get(@get('folder_id'))

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(Exercise::, NestedModelsConcern)

  Exercise