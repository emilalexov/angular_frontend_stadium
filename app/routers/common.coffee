define ->

  class Router extends Backbone.Router

    initialize: ->
      super
      @route /^accessToken\/(\w+)(\/.*)?$/, 'accessToken'

    accessToken: (token, path) ->
      @_applyAccessToken(token)
      window.location.replace("##{path}")
      window.location.reload()

    _applyAccessToken: (token) ->
      App.request('accessToken:set', token)


  init: ->
    new Router
