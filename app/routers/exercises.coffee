define [
  'pages/exercise/page'
], (
  ExercisePage
) ->

  class Router extends Marionette.AppRouter

    initialize: ->
      @listenTo App.vent, 'unsaved:changes', ->
        @unsavedChanges = true
        @currentURL = Backbone.history.getFragment()
      @listenTo App.vent, 'no:unsaved:changes', ->
        @unsavedChanges = false

    execute: (callback, args) ->
      if @unsavedChanges is true
        if !confirm 'Are you sure you want to leave without saving?'
          Backbone.history.navigate @currentURL, trigger: false
          return false
        else
          @unsavedChanges = false
          callback and callback.apply(@, args)
      else
        callback and callback.apply(@, args)

    appRoutes:
      'exercises': 'toFolder'
      'exercises/:id': 'root'
      'exercises/:id/:state': 'overview'

  class Controller extends Marionette.Controller

    toFolder: ->
      user = App.request('current_user')
      id = user.folders.findWhere(name: 'Exercises').get('id')
      path = ['exercises_folder', id]
      App.vent.trigger('redirect:to', path)

    root: (id) ->
      path = ['exercises', id, 'overview']
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new ExercisePage
        id: id
        state: state

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller