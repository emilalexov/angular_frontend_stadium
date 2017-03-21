define [
  'pages/program_templates/overview/page'
], (
  ProgramTemplateOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'program_templates': 'toFolder'
      'program_templates/:id': 'root'
      'program_templates/:id/:state': 'overview'

  class Controller extends Marionette.Controller

    toFolder: ->
      user = App.request('current_user')
      id = user.folders.findWhere(name: 'Programs').get('id')
      path = ['program_templates_folder', id]
      App.vent.trigger('redirect:to', path)

    root: (id) ->
      path = ['program_templates', id, 'overview']
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new ProgramTemplateOverviewPage
        id: id
        state: state

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
