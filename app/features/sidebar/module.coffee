define [
  './view'
], (
  SidebarView
) ->

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initVentListeners()

    _initVentListeners: ->
      @listenTo(@app.vent, 'app:layouts:main:render', @_renderSidebarView)

    _renderSidebarView: ->
      view = new SidebarView
      @app.request 'views:show', view,
        layout: 'main'
        region: 'menu'
