define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    triggers:
      'click':
        event: 'action'
        stopPropagation: false

    behaviors: ->
      stickit:
        bindings:
          ':el':
            observe: 'visible'
            visible: (value) -> value()
