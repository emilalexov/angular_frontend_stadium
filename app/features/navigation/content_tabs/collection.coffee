define [
  './model'
], (
  Model
)->

  class Collection extends Backbone.Collection

    model: Model

    constructor: ->
      @listenTo(@, 'activate', @_activate)
      super

    _activate: (id) ->
      model = @findWhere
        id: id
      if model
        @each (m) ->
          m.set('active', false)
        model.set('active', true)
        @trigger('activated', id)
