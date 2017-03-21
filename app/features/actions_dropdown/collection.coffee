define [
  './model'
], (
  Model
) ->

  class Collection extends Backbone.Collection

    model: Model
