define [
  'pages/personal_programs/overview/page'
  'pages/personal_programs/edit/page'
  'pages/personal_programs/list/page'
], (
  PersonalProgramsOverviewPage
  PersonalProgramsEditPage
  PersonalProgramsListPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'personal_programs/:id': 'overview'
      'personal_programs/:id/edit': 'edit'
      'personal_programs(/)': 'list'

  class Controller extends Marionette.Controller

    overview: (id, state) ->
      new PersonalProgramsOverviewPage
        id: id
        state: 'overview'
    edit: (id, state) ->
      new PersonalProgramsEditPage
        id: id
        state: 'edit'
    list: (id, state) ->
      new PersonalProgramsListPage
        state: 'list'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
