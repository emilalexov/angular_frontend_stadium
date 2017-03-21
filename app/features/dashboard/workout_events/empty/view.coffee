define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.ItemView

    tagName: 'tr'

    className: 'empty'

    template: template
