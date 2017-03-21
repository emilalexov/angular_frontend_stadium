define [
  './template'
], (
  template
) ->

  class StatsItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'gc-folder row'

    behaviors:

      stickit:
        bindings: ->
          'a': 'title'
