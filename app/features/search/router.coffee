define [
  'routers/custom'
], (
  CustomRouter
) ->

  class Router extends CustomRouter

    appRoutes:
      'search/:q(/:entityType)(/:searchScope)': 'search'

    initialize: ->
      super
      @listenTo(App.vent, 'search:cancel', @previous)

    previous: ->
      info = App.request('lastHash:get')
      hash = info?.hash || '#'
      Backbone.history.navigate hash,
        trigger: true

    onRoute: ->
      # NOTE: don't log history for SearchRouter actions
      false
