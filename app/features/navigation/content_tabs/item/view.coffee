define [
  './template'
], (
  template
)->

  class View extends Marionette.ItemView

    template: template

    tagName: 'li'

    behaviors:

      stickit:
        bindings:
          ':el':
            attributes: [
              name: 'class'
              observe: 'active'
              onGet: (value) ->
                value && 'active' || ''
            ]
          '[data-bind="title"]': 'title'

    triggers:
      'click': 'switch'
