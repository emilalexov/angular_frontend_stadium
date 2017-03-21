define [
  'pages/personal_properties/list/page'
], (
  PersonalPropertiesListPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'personal_properties': 'list'

  class Controller extends Marionette.Controller

    list: ->
      view = new PersonalPropertiesListPage
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
