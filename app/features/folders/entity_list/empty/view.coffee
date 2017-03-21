define [
  './template'
], (
  template
) ->

  class EntityEmptyView extends Marionette.ItemView

    template: template

    className: 'gc-global-list-splash'

    templateHelpers: ->
      singularName: @singularName

    initialize: (options) ->
      @singularName = _.chain(options.type).humanize().singularize().value()