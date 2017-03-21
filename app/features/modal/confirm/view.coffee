define [
  './model'
  './template'
], (
  ConfirmModel
  template
) ->

  class ModalConfirmView extends Marionette.ItemView

    template: template

    ui:
      confirmButton: '.confirm'
      cancelButton: '.cancel'
      modal: '.modal'

    events:
      'click @ui.confirmButton': 'confirmEvent'
      'click @ui.cancelButton': 'cancelEvent'
      'hidden.bs.modal @ui.modal': 'onModalClosed'

    behaviors:
      stickit:
        bindings:
          '.title': 'title'
          '.modal-body p': 'content'
          '.gc-rm-buttons .confirm': 'confirmBtn'
          '.gc-rm-buttons .cancel': 'cancelButton'

    initialize: (data)->
      @model = new ConfirmModel
      @model.set(data)

    confirmEvent: ->
      @model.get('confirmCallBack')?()

    cancelEvent: ->
      @model.get('cancelCallBack')?()

    onModalClosed: ->
      @trigger 'modal:closed'
