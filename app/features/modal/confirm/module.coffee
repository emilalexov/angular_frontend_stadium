define [
  './view'
], (
  ModalConfirmView
) ->

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initHandlers()

    _initHandlers: ->
      @app.reqres.setHandler('base:confirmationalModal', @_initModal)
      @app.reqres.setHandler('modal:confirm', @_initModal)
      @app.reqres.setHandler('modal:confirm:delete', @_initModalDelete)

    _initModal: (data) =>
      view = new ModalConfirmView data
      region = App.request('app:layouts:base').getRegion('modal')
      region.show(view)
      region.$el.modal('show')

      @listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()

    _initModalDelete: (model, callback) ->
      defer = new $.Deferred
      App.request 'modal:confirm',
        title: "Delete #{model.type}"
        content: "Are you sure you want to delete
          #{model.type} (#{model.get('name')})?"
        confirmBtn: 'Delete'
        confirmCallBack: ->
          model.destroy(wait: true)
            .then ->
              App.request 'messenger:explain', 'item.deleted',
                type: model.type

            .then(defer.resolve)
            .fail(defer.reject)

      defer.promise()
