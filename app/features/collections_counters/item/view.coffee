define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'gc-block'

    behaviors:
      stickit:
        bindings:
          'span': 'count'
          'label': 'label'
