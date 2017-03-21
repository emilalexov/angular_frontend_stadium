define [
  './template'
  './item/view'
], (
  template
  TemplateCollectionItemView
)->

  class TemplateCollectionView extends Marionette.CompositeView

    template: template

    className: 'gc-sidebar-folder'

    events:
      'click a:first .gc-sidebar-folder-icon': '_disableRedirect'

    ui:
      sidebarElements: '.gc-sidebar-sub'

    getChildView: (item) ->
      if typeof item.attributes.folder_id isnt 'undefined'
        TemplateCollectionItemView
      else
        TemplateCollectionView

    childViewOptions: (model, index) ->
      attributes:
        'data-category': @type.toLowerCase()
      type: @type
      name: model.get('name')
      collection: model.items

    childViewContainer: '.gc-sidebar-sub'

    templateHelpers: ->
      type: @type
      name: @name
      isFolder: true

    viewComparator: (model) ->
      [
        !!model.get('folder_id') && 2 || 1
        _.underscored(model.get('name'))
      ]

    initialize: (options)->
      @type = options.type
      @name = options.name

    _disableRedirect: (ev) ->
      ev.preventDefault()
