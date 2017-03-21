define [
  './template'
  './styles'
], (
  template
) ->

  class SpinnerView extends Marionette.LayoutView

    template: template

    className: 'gc-spinner'

    ui:
      clock: '.gc-busy-indicator-clock'
      pointer: '.pointer'
      message: '.message'

    initialize: ->
      @listenTo(@, 'start', @_start)
      @listenTo(@, 'stop', @_stop)
      @

    _start: =>
      @_messageTimeoutId = _.chain(@_showMessage)
        .bind(@)
        .delay(2000)
        .value()
      @_show()
      @_activate()

    _stop: =>
      clearTimeout(@_messageTimeoutId)
      @_hideMessage()
      @_deactivate(@_hide)

    _show: ->
      @ui.clock.stop()
        .show()

    _hide: ->
      @ui.clock.stop()
        .fadeOut('fast')

    _activate: ->
      @ui.pointer.stop()
        .fadeIn('fast')

    _deactivate: (cb) ->
      @ui.pointer.stop()
        .fadeOut 'fast', =>
          cb.apply(@)

    _showMessage: ->
      @ui.message.stop()
        .fadeIn('fast')

    _hideMessage: (cb) ->
      @ui.message.stop()
        .fadeOut('fast')
