define [
  'pages/video_library/list/page'
], (
  VideoLibraryListPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'videos(/)': 'root'
      'videos/:order': 'list'

  class Controller extends Marionette.Controller

    root: ->
      path = ['videos', 'recent']
      App.vent.trigger('redirect:to', path)

    list: (order) ->
      new VideoLibraryListPage
        state: 'list'
        order: order

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
