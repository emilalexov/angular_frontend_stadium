define [
  './template'
  './item/view'
], (
  template
  PersonalCollectionItemView
)->

  class SidebarPersonalRootFolderView extends Marionette.CompositeView

    key: 'SidebarPersonalRootFolderView'

    template: template

    className: 'gc-sidebar-cat'

    childView: PersonalCollectionItemView

    childViewContainer: '.gc-sidebar-sub'

    childViewOptions: ->
      type: @type

    templateHelpers: ->
      type: @type
      title: @title

    initialize: (options)->
      @type = options.type
      @title = options.title
