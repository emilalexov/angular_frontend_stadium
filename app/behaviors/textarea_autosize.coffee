define [
  'autosize'
], (
  autosize
)->

  class TextareaAutosize extends Marionette.Behavior

    key: 'textarea_autosize'

    behaviors:
      stickit:
        bindings:
          'textarea':
            afterUpdate: ->
              @_updateAutosizeDelayed()

    ui:
      editor: 'textarea'

    initialize: ->
      @_updateAutosizeDelayed = _.debounce(@_updateAutosize, 200)

    onShow: ->
      @_updateAutosizeDelayed()

    onBeforeDestroy: ->
      autosize.destroy(@ui.editor)

    _updateAutosize: ->
      autosize(@ui.editor)
