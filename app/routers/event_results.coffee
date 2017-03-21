define [
  'pages/workout_enter_result/page'
  'pages/event_results/page'
], (
  WorkoutEnterResultPage
  EventResultsPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'events/:event_id/results': 'results'
      'workout_enter_result(/)': 'root'

  class Controller extends Marionette.Controller

    root: ->
      new WorkoutEnterResultPage

    results: (eventId) ->
      new EventResultsPage(
        id: eventId
        state: 'root'
      )

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
