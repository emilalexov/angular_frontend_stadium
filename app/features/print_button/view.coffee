define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    tagName: 'button'

    className: 'btn'

    events:
      'click': '_print'

    _print: ->
      window.print()
