define [
  './group/view'
], (
  GroupModalView
) ->

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initHandlers()

    _initHandlers: ->
      @app.reqres.setHandler('modal:groups', @_initGroupsModal)

    _initGroupsModal: (model) =>
      view = new GroupModalView model: model
      region = App.request('app:layouts:base').getRegion('modal')
      region.show(view)
      region.$el.modal('show')

      @listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()
