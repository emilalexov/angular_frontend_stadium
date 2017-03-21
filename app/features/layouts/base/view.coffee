define [
  './template'
], (
  template
) ->

  class BaseLayoutView extends Marionette.LayoutView

    template: template

    el: 'body'

    regions:
      appRegion: 'region[data-name="app"]'
      modal: 'region[data-name="modal"]'

    initialize: ->
      @_initHandlers()

    _initHandlers: ->
      @listenTo(App.vent, 'body:change-class', @_changeClass)
      App.reqres.setHandler('app:layouts:base', => @)

    _changeClass: (className) =>
      @$el.removeClass().addClass(className)