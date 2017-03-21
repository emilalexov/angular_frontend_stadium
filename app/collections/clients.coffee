define [
  'models/client'
], (
  Client
) ->

  class Clients extends Backbone.Collection

    type: 'Clients'

    model: Client

    url: '/users'
