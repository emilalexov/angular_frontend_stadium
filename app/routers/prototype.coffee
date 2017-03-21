define [
  'views/prototype/ui-view'
], (
  UiView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'prototype/ui': 'ui'

  class Controller extends Marionette.Controller

    ui: ->
      view = new UiView
      App.baseView.appRegion.show(view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
