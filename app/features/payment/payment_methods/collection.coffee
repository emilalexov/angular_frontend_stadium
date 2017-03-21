define [
  './model'
], (
  Model
) ->

  class Cards extends Backbone.Collection

    url: '/cards'

    model: Model
