define [
  'pages/personal_workouts/overview/page'
  'pages/personal_workouts/edit/page'
  'pages/personal_workouts/list/page'
], (
  PersonalWorkoutOverviewPage
  PersonalWorkoutEditPage
  PersonalWorkoutListPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'personal_workouts/:id': 'overview'
      'personal_workouts/:id/edit': 'edit'
      'personal_workouts(/)': 'list'

  class Controller extends Marionette.Controller

    overview: (id, state) ->
      new PersonalWorkoutOverviewPage
        id: id
        state: 'overview'
    edit: (id, state) ->
      new PersonalWorkoutEditPage
        id: id
        state: 'edit'
    list: (id, state) ->
      new PersonalWorkoutListPage
        state: 'list'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
