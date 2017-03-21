define [
  'pages/workout_exercises/list/page'
], (
  WorkoutExercisesListPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'workout_exercises(/)': 'list'

  class Controller extends Marionette.Controller

    list: ->
      new WorkoutExercisesListPage
        state: 'list'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
