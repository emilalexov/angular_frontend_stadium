define [
  './template'
], (
  template
) ->
  class EmptyView extends Marionette.ItemView

    className: 'gc-properties-list-empty'

    template: template
