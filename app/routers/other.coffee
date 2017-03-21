define [
  'views/general/modal-library-preset-view'
], (
  LibraryPresetModal
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      '': 'root'
      'library-preset': 'loadPreset'

  class Controller extends Marionette.Controller

    root: ->
      Backbone.history.navigate '#welcome',
        trigger: true
        replace: true

    loadPreset: ->
      view = new LibraryPresetModal
      region = App.baseView.getRegion('modal')
      region.show(view)
      region.$el.modal('show')

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
