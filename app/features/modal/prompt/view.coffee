define [
  './template'
  './model'
], (
  template
  PromptModel
) ->

  class ModalPromptView extends Marionette.ItemView

    template: template

    className: 'modal-dialog modal-md'

    ui:
      confirmButton: '.confirm'
      cancelButton: '.cancel'
      modal: '.modal'

    events:
      'submit form': 'confirmEvent'
      'click @ui.cancelButton': 'cancelEvent'
      'hidden.bs.modal @ui.modal': 'onModalClosed'
      'keyup input': '_validateInput'

    behaviors:

      form_validation: true

      stickit:
        bindings:
          '.title': 'title'
          'label.control-label': 'label'
          '.gc-rm-buttons .confirm': 'confirmBtn'
          '.description':
            observe: 'description'
            visible: true
            updateView: true
          'input':
            observe: 'prompt'
            attributes: [
                name: 'type'
                observe: 'input_type'
            ]

    initialize: (data)->
      @model = new PromptModel(data)
      Backbone.Validation.bind(@)

    confirmEvent: ->
      str = _.trim @model.get('prompt')
      @model.set('prompt', str)
      return false unless @_isValid()

      @model.get('confirmCallBack')?(str)
      @trigger('modal:closed') if @model.get('dismiss_on_submit')

    cancelEvent: ->
      @model.get('cancelCallBack')?()

    onModalClosed: ->
      @trigger 'modal:closed'

    _validateInput: (ev) ->
      @_isValid()
      ev

    _isValid: ->
      $inputGroup = @$('.form-group')
      value = @model.get('prompt')
      errorMsg = @model.preValidate('prompt', value)
      @trigger('switchError', errorMsg, $inputGroup)
      !errorMsg
