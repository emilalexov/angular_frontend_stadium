define [
  './view'
], (
  HeaderView
) ->

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initVentListeners()

    _initVentListeners: ->
      @listenTo(@app.vent, 'app:layouts:main:render', @_renderHeaderView)

    _renderHeaderView: ->
      view = new HeaderView
      @app.request 'views:show', view,
        layout: 'main'
        region: 'header'
