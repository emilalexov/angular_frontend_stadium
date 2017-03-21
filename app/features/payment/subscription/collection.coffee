define [
  './model'
], (
  Model
) ->

  class Subscriptions extends Backbone.Collection

    model: Model

    current: ->
      @find( (model) -> _.include(['trialing', 'active'], model.get('status')) )