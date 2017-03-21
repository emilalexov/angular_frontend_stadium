define [
  './template'
], (
  template
) ->

  class AuthLayoutView extends Marionette.LayoutView

    template: template

    regions:
      content: 'region[data-name="content"]'

    templateHelpers:
      landingPath: (path) ->
        [
          document.location.origin.replace('app', 'www')
          path
        ].join('/')

    initialize: ->
      @_initHandlers()

    _initHandlers: ->
      App.reqres.setHandler('app:layouts:auth', => @)

    onShow: ->
      App.vent.trigger('body:change-class', 'auth')
