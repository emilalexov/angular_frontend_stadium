define [
  'pages/workout_templates/overview/page'
], (
  WorkoutTemplateOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'workout_templates': 'toFolder'
      'workout_templates/:id': 'root'
      'workout_templates/:id/:state': 'overview'

  class Controller extends Marionette.Controller

    toFolder: ->
      user = App.request('current_user')
      id = user.folders.findWhere(name: 'Workouts').get('id')
      path = ['workout_templates_folder', id]
      App.vent.trigger('redirect:to', path)

    root: (id) ->
      path = ['workout_templates', id, 'overview']
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new WorkoutTemplateOverviewPage
        id: id
        state: state

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
