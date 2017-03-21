define [
  './template'
], (
  template
)->
  class TemplateCollectionItemView extends Marionette.ItemView

    template: template

    className: 'gc-sidebar-item'

    behaviors:

      stickit:
        bindings:
          '.gc-sidebar-folder-name': 'name'

    templateHelpers: ->
      type: @type
      isFolder: false

    initialize: (options)->
      @type = options.type
