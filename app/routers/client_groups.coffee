define [
  'pages/client_groups/overview/page'
], (
  ClientGroupsOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'client_groups/:id(/)': 'root'
      'client_groups/:id/:state': 'overview'

  class Controller extends Marionette.Controller

    root: (id) ->
      path = ['client_groups', id, 'members']
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new ClientGroupsOverviewPage
        id: id
        state: state

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
