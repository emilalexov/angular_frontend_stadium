define ->

  (oMarionette) ->

    class DirtyHackView extends oMarionette.ItemView

      initialize: ->
        super
        @render()

      template: ->
        '<div/>'

      ui:
        first: 'div:first'

      _bindUIElements: ->
        result = super
        $.extend(@ui.first.constructor.fn.constructor::, $.fn.constructor::)
        result

    new DirtyHackView
