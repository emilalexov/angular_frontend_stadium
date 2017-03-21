define [
  './template'
], (
  template
) ->

  class MainLayoutView extends Marionette.LayoutView

    template: template

    className: 'gc-layout-main'

    regions:
      menu: '.gc-sidebar-wrapper'
      header: 'region[data-name="header"]'
      content: '.gc-main'
      modals: 'region[data-name="modals"]'

    initialize: ->
      @_initHandlers()

    _initHandlers: ->
      App.reqres.setHandler('app:layouts:main', => @)
      @listenTo @, 'show', =>
        App.vent.trigger('app:layouts:main:render', @)

    onShow: ->
      App.vent.trigger('body:change-class', 'main')
