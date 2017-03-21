define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.ItemView

    template: template

    className: 'gc-client-assignments-empty'

    templateHelpers: =>
      name: @options.name
