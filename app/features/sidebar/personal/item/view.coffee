define [
  './template'
], (
  template
)->
  class PersonalCollectionItemView extends Marionette.ItemView

    template: template

    className: 'gc-sidebar-item'

    behaviors:

      stickit:
        bindings:
          '[data-bind="name"]': 'name'

    templateHelpers: ->
      type: @type

    initialize: (options)->
      @type = options.type
