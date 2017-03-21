define [
  './model'
], (
  Model
) ->

  class ClientPerformance extends Backbone.Collection

    type: 'ClientPerformance'

    url: '/clients_performance'

    model: Model
