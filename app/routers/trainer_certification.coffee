define [
  'pages/trainer_certification/page'
], (
  TrainerCertification
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'trainer_certification(/)': 'root'

  class Controller extends Marionette.Controller

    root: ->
      new TrainerCertification

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller